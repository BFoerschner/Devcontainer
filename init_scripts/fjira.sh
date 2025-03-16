#!/usr/bin/env bash
VERSION=$(curl -s "https://api.github.com/repos/mk-5/fjira/releases/latest" | \grep -Po '"tag_name": *"\K[^"]*')
ARCH=$(uname -i)

if [[ $ARCH == x86_64* ]]; then
  echo "Downloading for X64 Architecture"
  URL="https://github.com/mk-5/fjira/releases/download/${VERSION}/fjira_Linux_x86_64.tar.gz"
elif [[ $ARCH == arm* ]] || [[ $ARCH == aarch* ]]; then
  echo "Downloading for ARM Architecture"
  URL="https://github.com/mk-5/fjira/releases/download/${VERSION}/fjira_Linux_arm64.tar.gz"
fi

wget -O fjira.tar.gz "$URL" && tar xf fjira.tar.gz fjira && chmod +x fjira && rm fjira.tar.gz
