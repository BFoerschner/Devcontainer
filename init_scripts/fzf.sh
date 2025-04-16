#!/usr/bin/env bash

if [ -f "$HOME"/.zshrc ]; then
  mv "$HOME"/.zshrc "$HOME"/.zshrc.bak
fi

git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf &&
  "$HOME"/.fzf/install --bin &&
  mv "$HOME"/.fzf/bin/fzf /usr/local/bin/fzf
rm -rf "$HOME"/.fzf

if [ -f "$HOME"/.zshrc.bak ]; then
  mv "$HOME"/.zshrc.bak "$HOME"/.zshrc
fi
