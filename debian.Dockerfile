FROM python:3.12-bookworm

ARG USER=appuser
ARG USER_UID=1001
ARG USER_GID=$USER_UID

ENV TZ=Europe/Berlin

WORKDIR /app

# Add non-root user
RUN groupadd --gid $USER_GID $USERNAME &&  \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    #apt-get update && \
    #&& apt-get install -y sudo \
    #echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    #chmod 0440 /etc/sudoers.d/$USERNAME

# Tell docker that all future commands should run as the appuser user
USER $USERNAME
