#!/usr/bin/env bash

install_cargo_tools() {
  cargo install bat --locked
  cargo install eza --locked
  cargo install fd-find --locked
  cargo install git-delta --locked
  cargo install ripgrep --locked
  cargo install du-dust --locked
  ln -s "$HOME"/.cargo/bin/dust "$HOME"/.local/bin/du
  cargo install termscp --locked
  cargo install silicon --locked
  cargo install procs --locked
  cargo install difftastic --locked
  cargo install choose --locked
  cargo install nu --locked
  cargo install just --locked
}
