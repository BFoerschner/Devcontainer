#!/usr/bin/env bash

eget_with_retry() {
  local max_attempts=2
  local delay=30
  local attempt=1

  while [ $attempt -le $max_attempts ]; do
    set +e
    eget "$@"
    local exit_code=$?
    set -e

    if [ $exit_code -eq 0 ]; then
      return 0
    else
      if [ $attempt -lt $max_attempts ]; then
        echo "eget failed (attempt $attempt/$max_attempts), retrying in ${delay}s..."
        sleep $delay
      fi
      ((attempt++))
    fi
  done

  echo "eget failed after $max_attempts attempts"
  return 1
}

install_terraform() {
  log "Installing terraform"
  TMP_DIR=$(mktemp -d)
  cd "$TMP_DIR" || exit
  git clone https://github.com/hashicorp/terraform
  cd terraform || exit
  go install
  rm -rf "$TMP_DIR"
}

install_k9s() {
  log "Installing k9s"
  eget "derailed/k9s" --to "$HOME/.local/bin" --asset ^musl --asset ^json --asset ^libgit --asset .tar.gz
}

install_pandoc() {
  log "Installing pandoc"
  eget_with_retry "jgm/pandoc" --to "$HOME/.local/bin" --asset ^musl --asset ^libgit --asset .tar.gz
}

install_lnav() {
  log "Installing lnav"
  eget_with_retry "tstack/lnav" --to "$HOME/.local/bin" --asset ^libgit --asset .zip
}

install_carapace() {
  log "Installing carapace"
  eget_with_retry "carapace-sh/carapace-bin" --to "$HOME/.local/bin" --asset ^musl --asset ^libgit --asset .tar.gz --file "carapace"
}

install_gh_cli() {
  log "Installing github cli"
  eget_with_retry "cli/cli" --to "$HOME/.local/bin" --asset ^musl --asset ^libgit --asset .tar.gz
}

install_tmux() {
  log "Installing tmux"
  TMPDIR=$(mktemp -d)

  eget_with_retry tmux/tmux --download-only --to "$TMPDIR/tmux.tar.gz"
  cd "$TMPDIR" || exit
  echo "$TMPDIR"

  TAR_OUTPUT=$(tar -tzf "$TMPDIR"/tmux.tar.gz) || {
    echo "Failed to list contents of tarball" >&2
    exit 1
  }
  echo "$TAR_OUTPUT"
  TMUX_SOURCE_DIR=$(echo "$TAR_OUTPUT" | head -n1 | cut -f1 -d'/')
  tar -xzf "$TMPDIR"/tmux.tar.gz
  cd "$TMUX_SOURCE_DIR" || exit

  ./configure && make
  make install

  cd "$HOME" || exit
  rm -rf "$TMPDIR"
}

install_tmux_plugin_manager() {
  log "Installing tmux plugin manager"
  TPM_PLUGINS_DIR="$HOME"/.config/tmux/plugins/tpm

  [ -d "$TPM_PLUGINS_DIR" ] && rm -rf "$TPM_PLUGINS_DIR"
  git clone https://github.com/tmux-plugins/tpm "$TPM_PLUGINS_DIR"
  "$TPM_PLUGINS_DIR"/scripts/install_plugins.sh
}

install_kubectl() {
  log "Installing kubectl"
  ARCH=$(uname -i)

  if [[ $ARCH == x86_64* ]]; then
    log "Downloading for X64 Architecture"
    URL="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  elif [[ $ARCH == arm* ]] || [[ $ARCH == aarch* ]]; then
    log "Downloading for ARM Architecture"
    URL="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
  fi

  TMP_DIR=$(mktemp -d) && cd "$TMP_DIR" || exit
  wget -O kubectl "$URL" && chmod +x ./*
  mv ./* "$HOME"/.local/bin
  cd "$HOME" && rm -rf "$TMP_DIR"
}

install_neovim() {
  log "Installing neovim (latest release)"
  INSTALL_DIR="/opt/nvim"
  OS=$(uname -s)
  ARCH=$(uname -m)
  TAG=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | jq -r .tag_name)

  # Determine asset and install directory
  if [ "$OS" = "Linux" ]; then
    if [ "$ARCH" = "x86_64" ]; then
      ARCH="nvim-linux-x86_64"
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
      ARCH="nvim-linux-arm64"
    else
      log "Unsupported architecture: $ARCH"
      exit 1
    fi
  else
    log "Unsupported OS: $OS"
    exit 1
  fi

  DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${TAG}/${ARCH}.tar.gz"
  TMP_DIR=$(mktemp -d)

  log "Downloading Neovim ${TAG} for ${OS} (${ARCH})"
  curl -L "$DOWNLOAD_URL" -o "$TMP_DIR/nvim.tar.gz"

  log "Extracting nvim.tar.gz to $TMP_DIR"
  tar -xzf "$TMP_DIR/nvim.tar.gz" -C "$TMP_DIR"

  log "Moving $TMP_DIR/$ARCH to $INSTALL_DIR"
  rm -rf "$INSTALL_DIR"
  mv "$TMP_DIR/$ARCH" "$INSTALL_DIR"

  log "Linking $INSTALL_DIR/bin/nvim to $HOME/.local/bin/nvim"
  ln -sf "$INSTALL_DIR/bin/nvim" "$HOME"/.local/bin/nvim

  log "Cleaning up $TMP_DIR"
  rm -rf "$TMP_DIR"
}

install_neovim_plugins() {
  log "Installing and initializing neovim plugins and necessary additional software (mainly mason)"

  # install python packages for neovim
  log "installing python"
  uv python install
  log "creating neovims venv"
  uv venv ~/.venvs/.nvim-venv
  log "installing neovim python libs"
  uv pip install -p ~/.venvs/.nvim-venv/bin/python pynvim neovim
  log "setting up neovim node libs"
  npm install -g neovim

  set +e          # Disable exit on error
  set +o pipefail # Disable pipefail
  nvim --headless '+Lazy! install' +qa
  nvim --headless "+Lazy! update" +qa
  nvim --headless "+Lazy! clean" +qa
  nvim --headless '+Lazy! install' +qa
  nvim --headless "+Lazy! update" +qa
  nvim --headless "+Lazy! sync" +qa
  nvim --headless -c "MasonToolsInstallSync" -c qall
  nvim --headless -c "lua require('nvim-treesitter')" -c "TSInstallSync all" -c "qall"
}

install_starship() {
  curl -sS https://starship.rs/install.sh | sh -s -- -y
}

install_timewarrior() {
  log "Installing timewarrior"
  TMP_DIR=$(mktemp -d)
  cd "$TMP_DIR" || exit

  git clone --recurse-submodules https://github.com/GothenburgBitFactory/timewarrior
  cd timewarrior || exit
  git checkout stable

  cmake -DCMAKE_BUILD_TYPE=release .
  make
  make install
  cd "$HOME" && rm -rf "$TMP_DIR"
}

install_tools() {
  install_starship
  install_terraform
  install_pandoc
  install_carapace
  install_gh_cli
  install_tmux
  install_tmux_plugin_manager
  install_kubectl
  install_timewarrior
  install_k9s
  install_lnav
  install_neovim
  install_neovim_plugins
}
