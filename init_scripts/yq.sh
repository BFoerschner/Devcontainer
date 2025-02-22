#!/bin/bash
VERSION=$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | \grep -Po '"tag_name": *"v\K[^"]*')
ARCH=$(uname -i)

if [[ $ARCH == x86_64* ]]; then
  echo "Downloading for X64 Architecture"
  URL="https://github.com/mikefarah/yq/releases/download/v${VERSION}/yq_linux_amd64"
elif [[ $ARCH == arm* ]] || [[ $ARCH == aarch* ]]; then
  echo "Downloading for ARM Architecture"
  URL="https://github.com/mikefarah/yq/releases/download/v${VERSION}/yq_linux_arm64"
fi

wget -O yq "$URL" && chmod +x "yq"
