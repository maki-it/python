FROM python:3.12-slim as base

# PYTHONDONTWRITEBYTECODE: Prevents Python from writing pyc files to disc (equivalent to python -B option) -> https://docs.python.org/3/using/cmdline.html#cmdoption-B
# PYTHONUNBUFFERED: Prevents Python from buffering stdout and stderr (equivalent to python -u -> https://docs.python.org/3/using/cmdline.html#cmdoption-u

# TODO Test performance if PYTHONDONTWRITEBYTECODE should be used

ENV LANG C.UTF-8 \
    LC_ALL C.UTF-8 \
    PYTHONDONTWRITEBYTECODE 1 \
    PYTHONFAULTHANDLER 1 \
    TZ=Europe/Berlin

FROM base as python-deps

COPY requirements.txt /requirements.txt

RUN pip install --prefix=/install -r requirements.txt


FROM base as runtime

ARG BASE_NAME \
    GIT_COMMIT_SHA \
    APP_DIR='/app'
    USERNAME='appuser' \
    USER_UID=1001 \
    
# Must be in own ARG for use with arg variable
ARG USER_GID=${USER_UID}

LABEL de.maki-it.image.base.title="Python base image" \
      de.maki-it.image.base.description="Python on Debian base image with non-root user" \
      de.maki-it.image.base.authors="Maki IT <kontakt@maki-it.de>" \
      de.maki-it.image.base.version="${PYTHON_VERSION}" \
      de.maki-it.image.base.source="https://git.prod.maki-it.de/base-images/python" \ 
      de.maki-it.image.base.digest=${GIT_COMMIT_SHA} \
      de.maki-it.image.base.name=${BASE_NAME}

WORKDIR ${APP_DIR}

COPY --from=python-deps /install /usr/local

RUN groupadd --gid ${USER_GID} ${USERNAME} &&  \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} && \
    chown --recursive ${USER_UID}:${USER_GID} ${APP_DIR}
    
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    #apt-get update && \
    #&& apt-get install -y sudo \
    #echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} && \
    #chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
