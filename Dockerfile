# Development container based on Ubuntu
# Build: just build
# Run:   just run

FROM ubuntu:25.10

ARG USERNAME=dev
ARG USER_UID=1001
ARG USER_HOME=/home/dev
ARG USER_SHELL=/bin/bash

ENV PATH="${USER_HOME}/.local/bin:${USER_HOME}/.local/share/mise/shims:${PATH}"
SHELL ["/bin/bash", "-c"]
COPY init.sh /build/init.sh

RUN \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  apt-utils \
  software-properties-common \
  curl \
  gnupg \
  sudo \
  ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN \
  useradd -m -s ${USER_SHELL} --no-log-init -u ${USER_UID} ${USERNAME} && \
  usermod -aG sudo ${USERNAME} && \
  echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
  chsh -s ${USER_SHELL} root && \
  chsh -s .local/share/mise/shims/nu ${USERNAME}

USER ${USERNAME}
WORKDIR ${USER_HOME}
RUN /build/init.sh
ENTRYPOINT ["tmux", "-u", "new-session", "-A", "-s", "main"]
