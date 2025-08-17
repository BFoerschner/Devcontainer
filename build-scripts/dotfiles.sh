#!/usr/bin/env bash

install_dotfiles() {
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME"/.local/bin init --apply "BFoerschner"
}
