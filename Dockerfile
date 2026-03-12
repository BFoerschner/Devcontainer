# Development container based on Ubuntu
# Build: just build
# Run:   just run

FROM ubuntu:25.10

ARG USERNAME=dev
ARG USER_UID=1001
ARG USER_SHELL=/bin/bash
ARG SNAPSHOT_DATE=""
ARG GITHUB_USER=""
SHELL ["/bin/bash", "-c", "-o", "pipefail"]

RUN --mount=type=secret,id=GITHUB_USER_PAT \
  if [ -n "${GITHUB_USER}" ] && [ ! -f /run/secrets/GITHUB_USER_PAT ]; then \
    echo "ERROR: GITHUB_USER_PAT secret is required when GITHUB_USER is set." >&2; \
    echo "Pass it with: --secret id=GITHUB_USER_PAT,env=GITHUB_USER_PAT" >&2; \
    exit 1; \
  fi

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
  ca-certificates \
  unminimize \
  && (yes || true) | unminimize \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN curl https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise sh

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
  if [ -z "${GITHUB_USER}" ]; then \
    echo "[dotfiles] No GITHUB_USER set, skipping chezmoi install"; \
  else \
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "/home/${USERNAME}/.local/bin" && \
    GITHUB_TOKEN="$(cat /run/secrets/GITHUB_USER_PAT)" \
    "/home/${USERNAME}/.local/bin/chezmoi" init --apply "${GITHUB_USER}"; \
  fi

WORKDIR /home/${USERNAME}
CMD ["/bin/bash"]
