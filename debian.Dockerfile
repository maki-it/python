FROM python:3.12-bookworm as base

FROM base as python-deps

COPY requirements.txt /requirements.txt

RUN pip install --prefix=/install -r requirements.txt


FROM base as runtime

LABEL org.opencontainers.image.title="Python base image" \
      org.opencontainers.image.description="Python on Debian base image with non-root user" \
      org.opencontainers.image.authors="Maki IT <kontakt@maki-it.de>" \
      org.opencontainers.image.version="${PYTHON_VERSION}" \
      org.opencontainers.image.source="https://git.prod.maki-it.de/base-images/python"

ENV TZ=Europe/Berlin

WORKDIR /app

ARG USERNAME=appuser
ARG USER_UID=1001
ARG USER_GID=$USER_UID

COPY --from=python-deps /install /usr/local

RUN groupadd --gid $USER_GID $USERNAME &&  \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    python3 -m pip install -r 
    
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    #apt-get update && \
    #&& apt-get install -y sudo \
    #echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    #chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
