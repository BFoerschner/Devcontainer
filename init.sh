#!/bin/bash

apt-get update && apt-get install -y software-properties-common

add-apt-repository -y ppa:neovim-ppa/unstable
apt-get update && apt-get install -y neovim

add-apt-repository -y ppa:longsleep/golang-backports
apt-get update && apt-get install -y golang-go

add-apt-repository -y ppa:lepapareil/hurl
apt-get update && apt-get install -y hurl

apt-get update && apt-get install -y \
  unminimize \
  dialog \
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
  cmake \
  nodejs \
  npm \
  python3 \
  python3-pip \
  python3-venv \
  lua5.4 \
  luarocks \
  perl \
  man \
  pipx \
  tidy \
  pandoc

yes | unminimize

# install rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
"$HOME"/.cargo/bin/rustup component add rust-analyzer

# install uv, installing python tools properly
curl -LsSf https://astral.sh/uv/install.sh | sh && rm "$HOME"/.zshrc

# dotfiles for cozy dev environment
git clone https://github.com/BFoerschner/dotfiles "$HOME"/.dotfiles && cd "$HOME"/.dotfiles && stow .

mkdir -p "$HOME/.local/bin"
cd "$HOME/.local/bin" || exit
for script in "$HOME"/init_scripts/*.sh; do
  echo "Installing $script"
  if "$script"; then
    echo "$script install successful" | tee -a /var/log/devimage_install.log
  else
    echo "$script install failed" | tee -a /var/log/devimage_install.log
    break
  fi
done

# cleaning up cache and dangling dependencies
apt-get autoremove --purge && apt-get clean
