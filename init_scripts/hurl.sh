#!/usr/bin/env bash

VERSION=$(curl -s "https://api.github.com/repos/Orange-OpenSource/hurl/releases/latest" | \grep -Po '"tag_name": *"\K[^"]*')
ARCH=$(uname -i)

if [[ $ARCH == x86_64* ]]; then
  echo "Downloading for X64 Architecture"
  URL="https://github.com/Orange-OpenSource/hurl/releases/download/${VERSION}/hurl_${VERSION}_amd64.deb"
elif [[ $ARCH == arm* ]] || [[ $ARCH == aarch* ]]; then
  echo "Downloading for ARM Architecture"
  URL="https://github.com/Orange-OpenSource/hurl/releases/download/${VERSION}/hurl_${VERSION}_arm64.deb"
fi

TMPDIR="/opt/hurltmp"
mkdir -p "$TMPDIR"
wget -O "$TMPDIR"/hurl.deb "$URL" && apt-get update && apt-get install "$TMPDIR"/hurl.deb && rm -rf "$TMPDIR"
