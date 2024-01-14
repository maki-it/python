FROM python:3.12.1-slim as base

# PYTHONDONTWRITEBYTECODE: Prevents Python from writing pyc files to disc (equivalent to python -B option) -> https://docs.python.org/3/using/cmdline.html#cmdoption-B
# PYTHONUNBUFFERED: Prevents Python from buffering stdout and stderr (equivalent to python -u -> https://docs.python.org/3/using/cmdline.html#cmdoption-u

# TODO Test performance if PYTHONDONTWRITEBYTECODE should be used

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONFAULTHANDLER=1 \
    TZ=Europe/Berlin

FROM base as python-deps

COPY requirements.txt /requirements.txt

RUN pip install --prefix=/install -r requirements.txt


FROM base as runtime

ARG BASE_NAME \
    GIT_COMMIT_SHA \
    APP_DIR='/app' \
    USERNAME='appuser' \
    USER_UID=12321 \
    BUILDTIME \
    REVISION \
    SOURCE_URL

# Must be in own ARG for use with arg variable
ARG USER_GID=${USER_UID}

LABEL org.opencontainers.image.base.title="Python ${PYTHON_VERSION} on Debian" \
      org.opencontainers.image.base.description="Python ${PYTHON_VERSION} on Debian with non-root user" \
      org.opencontainers.image.base.authors="Maki IT <kontakt@maki-it.de>" \
      org.opencontainers.image.base.version="${PYTHON_VERSION}" \
      org.opencontainers.image.base.revision=${REVISION} \
      org.opencontainers.image.base.created=${BUILDTIME} \
      org.opencontainers.image.base.source=${SOURCE_URL} \
      org.opencontainers.image.base.name=${BASE_NAME} \
      # Will be overwritten by child image
      org.opencontainers.image.title="Python ${PYTHON_VERSION} on Debian" \
      org.opencontainers.image.description="Python ${PYTHON_VERSION} on Debian with non-root user" \
      org.opencontainers.image.authors="Maki IT <kontakt@maki-it.de>" \
      org.opencontainers.image.version="${PYTHON_VERSION}" \
      org.opencontainers.image.revision=${REVISION} \
      org.opencontainers.image.created=${BUILDTIME} \
      org.opencontainers.image.source=${SOURCE_URL} \
      org.opencontainers.image.name=${BASE_NAME}

WORKDIR ${APP_DIR}

COPY --from=python-deps /install /usr/local

RUN groupadd --gid ${USER_GID} ${USERNAME} &&  \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} && \
    chown --recursive ${USER_UID}:${USER_GID} ${APP_DIR} && \
    apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    #apt-get update && \
    #&& apt-get install -y sudo \
    #echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} && \
    #chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
