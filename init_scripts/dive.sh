#!/usr/bin/env bash
VERSION=$(curl -sL "https://api.github.com/repos/wagoodman/dive/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
ARCH=$(uname -i)

if [[ $ARCH == x86_64* ]]; then
  echo "Downloading for X64 Architecture"
  URL=https://github.com/wagoodman/dive/releases/download/v${VERSION}/dive_${VERSION}_linux_amd64.deb
elif [[ $ARCH == arm* ]] || [[ $ARCH == aarch* ]]; then
  echo "Downloading for ARM Architecture"
  URL=https://github.com/wagoodman/dive/releases/download/v${VERSION}/dive_${VERSION}_linux_arm64.deb
fi

wget "$URL" -O ~/dive.deb
apt install ~/dive.deb
rm ~/dive.deb
