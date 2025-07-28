#!/usr/bin/env bash

update_os_archlinux() {
  IS_CONTAINER_INSTALL=${1:-false}

  mkdir -p "$HOME/.local/bin"

  # Update package database and system
  pacman -Syu --noconfirm

  # Common packages
  pacman -S --noconfirm \
    curl \
    automake \
    wget \
    unzip \
    zip \
    stow \
    cmake \
    gnupg \
    man \
    tidy \
    git \
    net-tools \
    jq \
    tar \
    zsh \
    ncdu \
    direnv \
    vim \
    pass \
    pass-otp \
    rsync \
    docker \
    docker-compose

  # Development dependencies
  pacman -S --noconfirm \
    expat \
    libxml2 \
    openssl \
    freetype2 \
    harfbuzz \
    fontconfig \
    libxcb \
    xclip \
    gcc \
    smbclient \
    clang \
    base-devel \
    pkgconf \
    libevent \
    ncurses \
    bison \
    python-pip

  # Create python3 symlink if it doesn't exist
  if ! command -v python3 &>/dev/null; then
    ln -sf /usr/bin/python /usr/bin/python3
  fi

  if $IS_CONTAINER_INSTALL; then
    # Arch-specific container optimizations
    pacman -S --noconfirm which
  fi
}

update_os_ubuntu() {
  IS_CONTAINER_INSTALL=${1:-false}

  mkdir -p "$HOME/.local/bin"
  apt-get update
  apt-get install -y apt-utils software-properties-common curl gnupg
  add-apt-repository -y ppa:git-core/ppa

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null
  apt-get update && apt-get upgrade -y && apt-get autoremove -y

  # common packages
  apt-get install -y \
    automake \
    wget \
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
    direnv \
    vim \
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
    libxml2-dev \
    libssl-dev \
    libfreetype6-dev \
    libexpat1-dev \
    libxcb-composite0-dev \
    libxcb-dev \
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
}

update_os() {
  IS_CONTAINER_INSTALL=${1:-false}

  # Auto-detect OS
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID="$ID"
  elif [ -f /etc/arch-release ]; then
    OS_ID="arch"
  elif [ -f /etc/debian_version ]; then
    OS_ID="ubuntu"
  else
    echo "Unable to detect OS"
    exit 1
  fi

  case "$OS_ID" in
  ubuntu | debian)
    update_os_ubuntu "$IS_CONTAINER_INSTALL"
    ;;
  archlinux | arch)
    update_os_archlinux "$IS_CONTAINER_INSTALL"
    ;;
  *)
    echo "Unsupported OS: $OS_ID"
    exit 1
    ;;
  esac
}
