FROM alpine:latest

# Create a group and user
ENV USER=docker
ENV UID=12345
ENV GID=23456
ENV TZ=Europe/Berlin

WORKDIR /app

# Add non-root user and install tzdata package 
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$UID" \
    "$USER" && \
    apk add tzdata

# Tell docker that all future commands should run as the appuser user
USER appuser
