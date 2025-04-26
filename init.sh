#!/bin/bash

apt-get update && apt-get install -y software-properties-common

# essentials
apt-get update && apt-get install -y \
  unminimize \
  apt-utils \
  gnupg \
  zsh \
  tmux \
  stow \
  git \
  sudo \
  curl \
  wget \
  docker.io \
  unzip \
  build-essential \
  libudev-dev \
  man \
  tidy \
  pandoc \
  cmake

# languages
apt-get update && apt-get install -y \
  nodejs \
  npm \
  python3 \
  python3-pip \
  python3-venv \
  pipx \
  lua5.4 \
  luarocks \
  perl

yes | unminimize

# installing dependencies for install-scripts
add-apt-repository -y ppa:longsleep/golang-backports
apt-get update && apt-get install -y golang-go

# install rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
if "$HOME"/.cargo/bin/rustup component add rust-analyzer; then
  echo "[success] rust-analyzer" | tee -a /var/log/devimage_install.log
else
  echo "[fail]    rust-analyzer" | tee -a /var/log/devimage_install.log
fi

# install uv, installing python tools properly
curl -LsSf https://astral.sh/uv/install.sh | sh &&
  rm "$HOME"/.zshrc

# dotfiles for cozy dev environment
git clone https://github.com/BFoerschner/dotfiles "$HOME"/.dotfiles &&
  cd "$HOME"/.dotfiles &&
  stow .

mkdir -p "$HOME/.local/bin"
cd "$HOME/.local/bin" || exit
for script in "$HOME"/init_scripts/*.sh; do
  echo "Installing $script"
  if "$script"; then
    echo "[success] $script" | tee -a /var/log/devimage_install.log
  else
    echo "[fail]    $script" | tee -a /var/log/devimage_install.log
  fi
done

chsh -s /bin/zsh root

# cleaning up cache and dangling dependencies
apt-get autoremove --purge && apt-get clean
rm -rf "$HOME"/.cache/*
