#!/usr/bin/env bash
set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR"/logging.sh

log "Installing mitmproxy"
VERSION=$(curl -s "https://api.github.com/repos/mitmproxy/mitmproxy/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
ARCH=$(uname -i)

if [[ $ARCH == x86_64* ]]; then
  log "Downloading for X64 Architecture"
  URL="https://downloads.mitmproxy.org/${VERSION}/mitmproxy-${VERSION}-linux-x86_64.tar.gz"
elif [[ $ARCH == arm* ]] || [[ $ARCH == aarch* ]]; then
  log "Downloading for ARM Architecture"
  URL="https://downloads.mitmproxy.org/${VERSION}/mitmproxy-${VERSION}-linux-aarch64.tar.gz"
fi

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"
wget -O mitmproxy.tar.gz "$URL" && tar -xf mitmproxy.tar.gz && rm mitmproxy.tar.gz
mv ./* "$HOME"/.local/bin
cd "$HOME"
rm -rf "$TMP_DIR"
