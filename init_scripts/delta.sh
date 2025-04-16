#!/usr/bin/env bash
VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases" | \grep -Po '"tag_name": *"\K[^"]*' | head -n1)
ARCH=$(uname -i)

if [[ $ARCH == x86_64* ]]; then
  echo "Downloading for X64 Architecture"
  URL=https://github.com/dandavison/delta/releases/download/${VERSION}/delta-${VERSION}-x86_64-unknown-linux-gnu.tar.gz
elif [[ $ARCH == arm* ]] || [[ $ARCH == aarch* ]]; then
  echo "Downloading for ARM Architecture"
  URL=https://github.com/dandavison/delta/releases/download/${VERSION}/delta-${VERSION}-aarch64-unknown-linux-gnu.tar.gz
fi

wget "$URL" -O "$HOME"/delta.tar.gz
mkdir -p "$HOME"/delta && tar -xf "$HOME"/delta.tar.gz -C "$HOME"/delta --strip-components 1
chmod +x "$HOME"/delta/delta
mv "$HOME"/delta/delta "$HOME"/.local/bin/delta
rm "$HOME"/delta.tar.gz
rm -rf "$HOME"/delta
