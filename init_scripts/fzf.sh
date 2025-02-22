#!/bin/bash

if [ -f ~/.zshrc ]; then
  mv ~/.zshrc ~/.zshrc.bak
fi

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &&
  ~/.fzf/install --bin &&
  mv ~/.fzf/bin/fzf /usr/local/bin/fzf
rm -rf ~/.fzf

if [ -f ~/.zshrc.bak ]; then
  mv ~/.zshrc.bak ~/.zshrc
fi
