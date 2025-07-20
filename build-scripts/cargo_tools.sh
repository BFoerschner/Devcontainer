#!/usr/bin/env bash
# Cargo/Rust tools installation

install_cargo_tools() {
  log "Installing Cargo tools..."

  log "bat: Cat clone with syntax highlighting"
  cargo install bat

  log "eza: Modern ls replacement"
  cargo install eza

  log "fd-find: Fast find alternative"
  cargo install fd-find

  log "git-delta: Git diff viewer"
  cargo install git-delta

  log "ripgrep: Fast grep alternative"
  cargo install ripgrep

  log "du-dust: Disk usage analyzer"
  cargo install du-dust
  ln -s "$HOME"/.cargo/bin/dust "$HOME"/.local/bin/du

  log "termscp: Terminal file transfer"
  cargo install termscp

  log "silicon: Code screenshot generator"
  cargo install silicon

  log "procs: replacement for ps"
  cargo install procs
}

