#!/bin/bash
VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases" | \grep -Po '"tag_name": *"\K[^"]*' | head -n1)
ARCH=$(uname -i)

if [[ $ARCH == x86_64* ]]; then
  echo "Downloading for X64 Architecture"
  URL=https://github.com/dandavison/delta/releases/download/${VERSION}/delta-${VERSION}-x86_64-unknown-linux-gnu.tar.gz
elif [[ $ARCH == arm* ]] || [[ $ARCH == aarch* ]]; then
  echo "Downloading for ARM Architecture"
  URL=https://github.com/dandavison/delta/releases/download/${VERSION}/delta-${VERSION}-aarch64-unknown-linux-gnu.tar.gz
fi

wget "$URL" -O ~/delta.tar.gz
mkdir -p ~/delta && tar -xf ~/delta.tar.gz -C ~/delta --strip-components 1
chmod +x ~/delta/delta
mv ~/delta/delta ~/.local/bin/delta
rm ~/delta.tar.gz
rm -rf ~/delta
