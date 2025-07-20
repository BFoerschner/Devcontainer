#!/usr/bin/env bash
# Go tools installation

install_go_tools() {
  log "Installing Go tools..."

  log "eget: Simple binary downloader"
  go install github.com/zyedidia/eget@latest

  log "lazydocker: Docker container management TUI"
  go install github.com/jesseduffield/lazydocker@latest

  log "lazygit: Git repository management TUI"
  go install github.com/jesseduffield/lazygit@latest

  log "mmv: Multi-file renaming tool"
  go install github.com/itchyny/mmv/cmd/mmv@latest

  log "nap: Code snippet manager"
  go install github.com/maaslalani/nap@main

  log "fzf: Fuzzy finder"
  go install github.com/junegunn/fzf@latest

  log "duf: Disk usage utility"
  go install github.com/muesli/duf@latest
  ln -s /usr/bin/duf "$HOME"/.local/bin/df

  log "dive: Docker image layer explorer"
  go install github.com/wagoodman/dive@latest

  log "yq: YAML processor"
  go install github.com/mikefarah/yq/v4@latest

  log "direnv: Environment variable manager"
  go install github.com/direnv/direnv@latest

  log "tea: Gitea CLI client"
  go install code.gitea.io/tea@v0.10.1
}

