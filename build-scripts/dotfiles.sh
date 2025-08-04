#!/usr/bin/env ${1|bash,sh|}
# shellcheck source-path=./build-scripts

install_chezmoi() {
  log "Installing chezmoi"
  TMP_DIR=$(mktemp -d)
  cd "$TMP_DIR" || exit
  git clone https://github.com/twpayne/chezmoi.git
  cd chezmoi || exit
  latest_tag=$(git tag --sort=-version:refname | head -1)
  git checkout "$latest_tag"
  make install-from-git-working-copy
  rm -rf "$TMP_DIR"
}

install_dotfiles() {
  install_chezmoi

  cd "$HOME" && chezmoi init --apply BFoerschner
}
