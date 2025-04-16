#!/usr/bin/env bash

VERSION=$(curl -s "https://api.github.com/repos/mitmproxy/mitmproxy/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
ARCH=$(uname -i)

if [[ $ARCH == x86_64* ]]; then
  echo "Downloading for X64 Architecture"
  URL="https://downloads.mitmproxy.org/${VERSION}/mitmproxy-${VERSION}-linux-x86_64.tar.gz"
elif [[ $ARCH == arm* ]] || [[ $ARCH == aarch* ]]; then
  echo "Downloading for ARM Architecture"
  URL="https://downloads.mitmproxy.org/${VERSION}/mitmproxy-${VERSION}-linux-aarch64.tar.gz"
fi

wget -O mitmproxy.tar.gz "$URL" && tar -xf mitmproxy.tar.gz && rm mitmproxy.tar.gz
