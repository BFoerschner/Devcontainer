#!/usr/bin/env bash

# Determine if we need sudo
use_sudo=""
if [ "$EUID" -ne 0 ]; then
  use_sudo="sudo"
fi

setup_environment() {
  export PATH="/usr/bin/:$PATH"
  export PATH="/usr/local/bin/:$PATH"
  export PATH="$HOME/.local/bin:$PATH"
  export KUBE_EDITOR=nvim
}

install_dotfiles() {
  echo "Installing dotfiles"
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME"/.local/bin init --apply "BFoerschner"
}

install_mise_and_tools() {
  curl https://mise.run/bash | sh
  mise install || true
  MISE_AQUA_GITHUB_ATTESTATIONS=false mise install gh

  eval "$(mise activate bash)"
}

install_tpm() {
  [ -d ~/.tmux/plugins/tpm ] && (cd ~/.tmux/plugins/tpm && git pull) || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && tmux source ~/.tmux.conf 2>/dev/null
  "$HOME"/.tmux/plugins/tpm/scripts/install_plugins.sh
}

cleanup_caches() {
  go clean -cache
  go clean -modcache
  uv cache clean
  [ -d "$HOME"/.cargo/registry ] && rm -rf "$HOME"/.cargo/registry

  # if apt-get exists, then clean cache
  if command -v apt-get &>/dev/null; then
    $use_sudo apt-get clean -y
    $use_sudo apt-get autoclean -y
    $use_sudo apt-get autoremove -y
  fi

  # clean logs, temp files and caches
  $use_sudo find /var/log -type f -delete || true
  $use_sudo find /var/log -type d -empty -delete || true
  find /root/.cache -type f -delete 2>/dev/null || $use_sudo find /root/.cache -type f -delete || true
  find /root/.cache -type d -empty -delete 2>/dev/null || $use_sudo find /root/.cache -type d -empty -delete || true

  mise cache clear
}

update_os() {
  local IS_CONTAINER_INSTALL="${1:-false}"
  mkdir -p "$HOME/.local/bin"

  $use_sudo add-apt-repository -y ppa:git-core/ppa # git
  $use_sudo apt-get update
  $use_sudo apt-get upgrade -y
  $use_sudo apt-get autoremove -y

  # common packages
  $use_sudo apt-get install -y \
    automake \
    wget \
    fish \
    unzip \
    zip \
    stow \
    cmake \
    man \
    tidy \
    git \
    net-tools \
    jq \
    tar \
    zsh \
    ncdu \
    xmlstarlet \
    pass \
    pass-otp \
    rsync

  # dependencies
  $use_sudo apt-get install -y \
    expat \
    locales \
    libxml2-dev \
    libssl-dev \
    libfreetype6-dev \
    libexpat1-dev \
    libxcb-composite0-dev \
    libxcb1-dev \
    libharfbuzz-dev \
    libfontconfig1-dev \
    g++ \
    libsmbclient \
    libsmbclient-dev \
    libonig-dev \
    libclang-dev \
    build-essential \
    pkg-config \
    libevent-dev \
    libncurses-dev \
    bison \
    python3-pip \
    python3-venv

  if $IS_CONTAINER_INSTALL; then
    $use_sudo apt-get install -y unminimize
    yes | unminimize 2>/dev/null || true
  fi

  echo "LC_ALL=en_US.UTF-8" >>/etc/environment
  echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
  echo "LANG=en_US.UTF-8" >/etc/locale.conf
  locale-gen en_US.UTF-8
}

download_blink_cmp_binary() {
  local plugin_dir="$HOME/.local/share/nvim/lazy/blink.cmp"
  local target_dir="$plugin_dir/target/release"

  if [ ! -d "$plugin_dir" ]; then
    echo "blink.cmp: plugin not found, skipping binary download"
    return 0
  fi

  local tag
  tag=$(git -C "$plugin_dir" describe --tags --exact-match 2>/dev/null) || {
    echo "blink.cmp: not on a tagged version, skipping binary download"
    return 0
  }

  local arch
  arch=$(uname -m)
  case "$arch" in
    aarch64 | arm64) arch="aarch64" ;;
    x86_64) arch="x86_64" ;;
    *)
      echo "blink.cmp: unsupported architecture: $arch"
      return 0
      ;;
  esac

  local libc="gnu"
  if [ -f /etc/alpine-release ]; then
    libc="musl"
  elif command -v ldd &>/dev/null && ldd --version 2>&1 | grep -qi musl; then
    libc="musl"
  fi

  local triple="${arch}-unknown-linux-${libc}"
  local lib_filename="libblink_cmp_fuzzy.so"
  local url="https://github.com/saghen/blink.cmp/releases/download/${tag}/${triple}.so"

  echo "blink.cmp: downloading pre-built binary for ${triple} (${tag})"
  mkdir -p "$target_dir"

  if curl -fsSL -o "$target_dir/${lib_filename}" "$url"; then
    echo "blink.cmp: binary downloaded successfully"
  else
    echo "blink.cmp: failed to download binary from $url"
    return 0
  fi

  curl -fsSL -o "$target_dir/${lib_filename}.sha256" "${url}.sha256" || true
  printf '%s' "$tag" >"$target_dir/version"
}

download_supermaven_binary() {
  local data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"

  local arch
  arch=$(uname -m)
  case "$arch" in
    aarch64 | arm64) arch="aarch64" ;;
    x86_64) arch="x86_64" ;;
    *)
      echo "supermaven: unsupported architecture: $arch"
      return 0
      ;;
  esac

  local binary_dir="$data_dir/supermaven/binary/v20/linux-${arch}"
  local binary_path="$binary_dir/sm-agent"

  echo "supermaven: querying download URL for linux/${arch}"

  local api_response
  api_response=$(curl -fsSL "https://supermaven.com/api/download-path-v2?platform=linux&arch=${arch}&editor=neovim") || {
    echo "supermaven: failed to query download API"
    return 0
  }

  local download_url
  download_url=$(echo "$api_response" | jq -r '.downloadUrl')

  if [ -z "$download_url" ] || [ "$download_url" = "null" ]; then
    echo "supermaven: no download URL returned"
    return 0
  fi

  echo "supermaven: downloading sm-agent"
  mkdir -p "$binary_dir"

  if curl -fsSL -o "$binary_path" "$download_url"; then
    chmod +x "$binary_path"
    echo "supermaven: binary downloaded successfully to $binary_path"
  else
    echo "supermaven: failed to download binary"
    return 0
  fi
}

install_neovim_plugins() {
  set -e

  eval "$(mise activate bash)"

  # install python packages for neovim
  echo "installing python"
  uv python install
  echo "creating neovims venv"
  uv venv ~/.venvs/.nvim-venv --clear
  echo "installing neovim python libs"
  uv pip install -p ~/.venvs/.nvim-venv/bin/python pynvim neovim
  echo "setting up neovim node libs"
  npm install -g neovim
  npm install -g tree-sitter-cli

  bash -lc "setsid nvim --headless \"+lua require('lazy').sync({wait=true,show=false,concurrency=1})\" +qa & pid=\$!; sleep 10; kill -KILL -\$pid; wait \$pid 2>/dev/null || true"

  nvim --headless \
    -c "lua require('lazy').sync({ wait = true })" \
    -c "lua require('nvim-treesitter')" \
    -c "TSInstall all" \
    -c "MasonToolsInstall" \
    -c "MasonUpdate" \
    -c "lua vim.defer_fn(function() vim.cmd('qa!') end, 120000)" &

  NVIM_PID=$!

  # Wait for process with timeout
  timeout 120 tail --pid=$NVIM_PID -f /dev/null || true

  # Check if Mason installed successfully
  if [ -d "$HOME/.local/share/nvim/mason/bin" ]; then
    echo "Mason tools installed successfully:"
    ls -la "$HOME/.local/share/nvim/mason/bin/"
  else
    echo "Mason installation failed!"
    exit 1
  fi

  # Download plugin binaries directly with curl (after lazy.sync so plugins are at final versions)
  download_blink_cmp_binary
  download_supermaven_binary
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  update_os true
  install_dotfiles
  install_mise_and_tools
  install_tpm
  install_neovim_plugins
  cleanup_caches
fi
