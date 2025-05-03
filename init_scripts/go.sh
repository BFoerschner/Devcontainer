#!/usr/bin/env bash
set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR"/logging.sh

LATEST_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1)
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
if [ "$ARCH" = "x86_64" ]; then
  ARCH="amd64"
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
  ARCH="arm64"
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

URL="https://go.dev/dl/${LATEST_VERSION}.${OS}-${ARCH}.tar.gz"

mkdir -p "$HOME"/.local/share
log "downloading and unpacking go to $HOME/.local/share"
curl -fsSL "$URL" | tar -xz -C "$HOME"/.local/share/
