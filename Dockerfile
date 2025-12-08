FROM ubuntu:rolling

ARG MISE_GITHUB_TOKEN
ENV PATH="~/.local/bin:~/.local/share/mise/shims:${PATH}"
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
  useradd -m -s /bin/bash -u 1001 dev && \
  usermod -aG sudo dev && \
  echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN \
  chsh -s /bin/bash root && \
  chsh -s .local/share/mise/shims/nu dev

USER dev
RUN MISE_GITHUB_TOKEN=${MISE_GITHUB_TOKEN} /build/init.sh
WORKDIR /home/dev
ENTRYPOINT tmux -u new-session -A -s main
