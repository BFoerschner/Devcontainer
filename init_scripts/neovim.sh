#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/logging.sh

INSTALL_DIR="/opt/nvim"
OS=$(uname -s)
ARCH=$(uname -m)
TAG=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | jq -r .tag_name)
if ((EUID == 0)); then
  SUDO=""
else
  SUDO="sudo"
fi

# Determine asset and install directory
if [ "$OS" = "Linux" ]; then
  if [ "$ARCH" = "x86_64" ]; then
    ARCH="nvim-linux-x86_64"
  elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    ARCH="nvim-linux-arm64"
  else
    log "Unsupported architecture: $ARCH"
    exit 1
  fi
else
  log "Unsupported OS: $OS"
  exit 1
fi

DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${TAG}/${ARCH}.tar.gz"
TMP_DIR=$(mktemp -d)

log "Downloading Neovim ${TAG} for ${OS} (${ARCH})"
curl -L "$DOWNLOAD_URL" -o "$TMP_DIR/nvim.tar.gz"

log "Extracting nvim.tar.gz to $TMP_DIR"
tar -xzf "$TMP_DIR/nvim.tar.gz" -C "$TMP_DIR"

log "Moving $TMP_DIR/$ARCH to $INSTALL_DIR"
$SUDO rm -rf "$INSTALL_DIR"
$SUDO mv "$TMP_DIR/$ARCH" "$INSTALL_DIR"

log "Linking $INSTALL_DIR/bin/nvim to $HOME/.local/bin/nvim"
$SUDO ln -sf "$INSTALL_DIR/bin/nvim" "$HOME"/.local/bin/nvim

log "Cleaning up $TMP_DIR"
rm -rf "$TMP_DIR"
