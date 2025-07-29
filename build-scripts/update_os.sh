#!/usr/bin/env bash

update_os() {
  CONTAINER_INSTALL=${1:-false}

  mkdir -p "$HOME/.local/bin"
  apt-get update
  apt-get install -y apt-utils software-properties-common curl gnupg
  add-apt-repository -y ppa:git-core/ppa
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
    rsync

  # dependencies
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
    build-essential \
    pkg-config \
    libevent-dev \
    libncurses-dev \
    bison \
    python3-pip \
    python3-venv

  if $CONTAINER_INSTALL; then
    apt-get install -y unminimize
    yes | unminimize 2>/dev/null || true
  fi
}
