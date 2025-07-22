#!/usr/bin/env bash

update_os() {
  mkdir -p "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"

  # Update system
  apt-get update && apt-get upgrade -y && apt-get autoremove -y

  # Install nice to have packages
  apt-get install -y \
    curl \
    automake \
    wget \
    unzip \
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
    rsync

  # Install dependencies
  apt-get install -y \
    expat \
    libxml2-dev \
    libssl-dev \
    libfreetype6-dev \
    libexpat1-dev \
    libxcb-composite0-dev \
    libharfbuzz-dev \
    libfontconfig1-dev \
    g++ \
    libsmbclient \
    libsmbclient-dev \
    libclang-dev \
    software-properties-common \
    build-essential \
    pkg-config \
    libevent-dev \
    libncurses-dev \
    bison \
    pass \
    python3-pip \
    python3-venv

  # Handle container environment
  if grep -q docker /proc/1/cgroup 2>/dev/null; then
    apt-get install -y unminimize
    yes | unminimize 2>/dev/null
  fi
}
