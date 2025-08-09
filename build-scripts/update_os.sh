#!/usr/bin/env bash

update_os() {
  IS_CONTAINER_INSTALL=${1:-false}

  mkdir -p "$HOME/.local/bin"
  apt-get update
  apt-get install -y apt-utils software-properties-common curl gnupg
  apt-add-repository ppa:fish-shell/release-4 # fish
  add-apt-repository -y ppa:git-core/ppa      # git
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null

  apt-get update && apt-get upgrade -y && apt-get autoremove -y

  # common packages
  apt-get install -y \
    automake \
    wget \
    fish \
    unzip \
    zip \
    stow \
    cmake \
    man \
    tidy \
    git \
    net-tools \
    jq \
    tar \
    zsh \
    ncdu \
    vim \
    xmlstarlet \
    pass \
    pass-otp \
    rsync \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

  # dependencies
  apt-get install -y \
    expat \
    sudo \
    locales \
    libxml2-dev \
    libssl-dev \
    libfreetype6-dev \
    libexpat1-dev \
    libxcb-composite0-dev \
    libxcb1-dev \
    libharfbuzz-dev \
    libfontconfig1-dev \
    g++ \
    libsmbclient \
    libsmbclient-dev \
    libclang-dev \
    build-essential \
    pkg-config \
    libevent-dev \
    libncurses-dev \
    bison \
    python3-pip \
    python3-venv

  if $IS_CONTAINER_INSTALL; then
    apt-get install -y unminimize
    yes | unminimize 2>/dev/null || true
  fi

  echo "LC_ALL=en_US.UTF-8" >>/etc/environment
  echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
  echo "LANG=en_US.UTF-8" >/etc/locale.conf
  locale-gen en_US.UTF-8
}
