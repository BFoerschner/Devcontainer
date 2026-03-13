FROM ubuntu:25.10

ARG USERNAME=dev
ARG USER_UID=1001
ARG USER_SHELL=/bin/bash
ARG SNAPSHOT_DATE=""
ARG USER_GITHUB=""
SHELL ["/bin/bash", "-c", "-o", "pipefail"]

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN SNAP="${SNAPSHOT_DATE:-$(date -u +%Y%m%dT000000Z)}" && \
  echo "$SNAP" > /etc/apt-snapshot-date && \
  sed -i "s|http://archive.ubuntu.com/ubuntu|http://snapshot.ubuntu.com/ubuntu/${SNAP}|g" /etc/apt/sources.list.d/ubuntu.sources && \
  sed -i "s|http://security.ubuntu.com/ubuntu|http://snapshot.ubuntu.com/ubuntu/${SNAP}|g" /etc/apt/sources.list.d/ubuntu.sources

# hadolint ignore=DL3008
RUN \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential \
  software-properties-common \
  curl \
  gnupg \
  sudo \
  unzip \
  zip \
  git \
  zsh \
  ncdu \
  xmlstarlet \
  pass \
  pass-otp \
  rsync \
  openssh-client \
  openssh-server \
  unminimize \
  && (yes || true) | unminimize \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN \
  mkdir -p /run/sshd && \
  sed -i 's/#\?AllowAgentForwarding.*/AllowAgentForwarding yes/' /etc/ssh/sshd_config && \
  sed -i 's/#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

RUN \
  groupadd -f docker && \
  useradd -m -s ${USER_SHELL} --no-log-init -u ${USER_UID} ${USERNAME} && \
  usermod -aG sudo,docker ${USERNAME} && \
  echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
  chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
# hadolint ignore=SC2016
RUN echo 'eval "$(mise activate bash)"' >> ~/.bashrc
# Dotfiles
RUN --mount=type=secret,id=GITHUB_USER_PAT,uid=${USER_UID} \
  if [ -z "${USER_GITHUB}" ]; then \
  echo "[dotfiles] No GITHUB_USER set, skipping chezmoi install"; \
  else \
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "/home/${USERNAME}/.local/bin" \
  && if [ -f /run/secrets/GITHUB_USER_PAT ]; then \
  GITHUB_TOKEN="$(cat /run/secrets/GITHUB_USER_PAT)"; \
  export GITHUB_TOKEN; \
  fi \
  && "/home/${USERNAME}/.local/bin/chezmoi" init --apply "${USER_GITHUB}"; \
  fi

# Import SSH public keys from GitHub
RUN mkdir -p ~/.ssh && chmod 700 ~/.ssh && \
  if [ -n "${USER_GITHUB}" ]; then \
  curl -fsSL "https://github.com/${USER_GITHUB}.keys" > ~/.ssh/authorized_keys && \
  chmod 600 ~/.ssh/authorized_keys; \
  fi

WORKDIR /home/${USERNAME}
EXPOSE 22
CMD ["sudo", "/usr/sbin/sshd", "-D"]
