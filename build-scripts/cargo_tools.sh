#!/usr/bin/env bash

install_cargo_tools() {
  cargo install bat
  cargo install eza
  cargo install fd-find
  cargo install git-delta
  cargo install ripgrep
  cargo install du-dust
  ln -s "$HOME"/.cargo/bin/dust "$HOME"/.local/bin/du
  cargo install termscp
  cargo install silicon
  cargo install procs
  cargo install difftastic
  cargo install choose
  cargo install nu
  cargo install just
}
