#!/usr/bin/env ${1|bash,sh|}
# shellcheck source-path=./build-scripts

install_dotfiles() {
  [ -d "$HOME"/.dotfiles ] && rm -rf "$HOME"/.dotfiles
  [ -f "$HOME"/.zshrc ] && rm "$HOME"/.zshrc
  [ -f "$HOME"/.bashrc ] && rm "$HOME"/.bashrc
  git clone https://github.com/BFoerschner/dotfiles "$HOME"/.dotfiles
  cd "$HOME"/.dotfiles && stow .
}
