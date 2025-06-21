#!/usr/bin/env bash
set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR"/logging.sh

log "Installing kubectl"
ARCH=$(uname -i)

if [[ $ARCH == x86_64* ]]; then
  log "Downloading for X64 Architecture"
  URL="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

elif [[ $ARCH == arm* ]] || [[ $ARCH == aarch* ]]; then
  log "Downloading for ARM Architecture"
  URL="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
fi

TMP_DIR=$(mktemp -d) && cd "$TMP_DIR"
wget -O kubectl "$URL" && chmod +x ./*
mv ./* "$HOME"/.local/bin
cd "$HOME" && rm -rf "$TMP_DIR"
