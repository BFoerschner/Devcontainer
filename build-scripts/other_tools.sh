#!/usr/bin/env bash
# other tool installations

install_pass_otp() {
  log "Installing otp-extension for pass"
  TMP_DIR=$(mktemp -d)
  cd "$TMP_DIR" || exit
  git clone https://github.com/tadfisher/pass-otp
  cd pass-otp || exit
  if ((EUID == 0)); then
    make install
  else
    sudo make install
  fi
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

install_pandoc() {
  log "Installing pandoc"
  eget "jgm/pandoc" --to "$HOME/.local/bin" --asset ^musl --asset ^libgit --asset .tar.gz
}

install_gh_cli() {
  log "Installing github cli"
  eget "cli/cli" --to "$HOME/.local/bin" --asset ^musl --asset ^libgit --asset .tar.gz
}

install_tmux() {
  log "Installing tmux"
  TMPDIR=$(mktemp -d)

  eget tmux/tmux --download-only --to "$TMPDIR/tmux.tar.gz"
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
  if ((EUID == 0)); then
    make install
  else
    sudo make install
  fi

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

install_docker() {
  log "Installing docker"
  # check if we need sudo or not
  if [[ $EUID -ne 0 ]]; then
    PRIVILEGE="sudo"
  else
    PRIVILEGE=""
  fi

  log "Installing Docker..."
  curl -fsSL https://get.docker.com | ${PRIVILEGE} sh
  docker --version && log "Docker installation complete"
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
  if ((EUID == 0)); then
    SUDO=""
  else
    SUDO="sudo"
  fi

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
  $SUDO rm -rf "$INSTALL_DIR"
  $SUDO mv "$TMP_DIR/$ARCH" "$INSTALL_DIR"

  log "Linking $INSTALL_DIR/bin/nvim to $HOME/.local/bin/nvim"
  $SUDO ln -sf "$INSTALL_DIR/bin/nvim" "$HOME"/.local/bin/nvim

  log "Cleaning up $TMP_DIR"
  rm -rf "$TMP_DIR"
}

install_neovim_plugins() {
  log "Installing and initializing neovim plugins and necessary additional software"

  # install python packages for neovim
  log "installing python"
  uv python install
  log "creating neovims venv"
  uv venv ~/.venvs/.nvim-venv
  log "installing neovim python libs"
  uv pip install -p ~/.venvs/.nvim-venv/bin/python pynvim neovim
  log "setting up neovim node libs"
  npm install -g neovim

  # opening neovim and giving it time to install all the stuff
  SLEEP_SECONDS=180

  set +e          # Disable exit on error
  set +o pipefail # Disable pipefail
  nvim --headless '+Lazy! install' +qa
  nvim --headless "+Lazy! update" +qa
  nvim --headless "+Lazy! clean" +qa
  nvim --headless '+Lazy! install' +qa
  nvim --headless "+Lazy! update" +qa
  nvim --headless "+Lazy! sync" +qa
  LSP_CFG=(
    "docker-compose-language-service"
    "tailwindcss-language-server"
    "dockerfile-language-server"
    "yaml-language-server"
    "bash-language-server"
    "vue-language-server"
    "lua-language-server"
    "markdownlint-cli2"
    "js-debug-adapter"
    "terraform-ls"
    "markdown-toc"
    "shellcheck"
    "eslint-lsp"
    "goimports"
    "prettier"
    "marksman"
    "json-lsp"
    "hadolint"
    "codelldb"
    "pyright"
    "lemminx"
    "gofumpt"
    "tflint"
    "stylua"
    "vtsls"
    "shfmt"
    "gopls"
    "delve"
    "black"
  )
  MASON_DEPS="{$(printf "'%s', " "${LSP_CFG[@]}")}"
  nvim --headless -c "lua require('mason').setup()" -c "lua require('mason.api.command').MasonInstall($MASON_DEPS)" -c "quitall"
  nvim --headless -c "TSInstall all" -c "sleep $SLEEP_SECONDS" -c "quitall"
}

install_other_tools() {
  install_pass_otp
  install_terraform
  install_pandoc
  install_gh_cli
  install_tmux
  install_tmux_plugin_manager
  install_docker
  install_kubectl
  install_neovim
  install_neovim_plugins
}
