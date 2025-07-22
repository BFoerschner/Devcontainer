#!/usr/bin/env bash

install_go() {
  LATEST_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1)
  OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
  ARCH="$(uname -m)"
  if [ "$ARCH" = "x86_64" ]; then
    ARCH="amd64"
  elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    ARCH="arm64"
  else
    echo "Unsupported architecture: $ARCH"
    exit 1
  fi

  URL="https://go.dev/dl/${LATEST_VERSION}.${OS}-${ARCH}.tar.gz"

  mkdir -p "$HOME"/.local/share
  log "downloading and unpacking go to $HOME/.local/share"
  curl -fsSL "$URL" | tar -xz -C "$HOME"/.local/share/
}

install_fnm() {
  curl -fsSL https://fnm.vercel.app/install | bash
  eval "$(fnm env)"
  fnm install --latest
}

install_rust() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
  rustup component add rust-analyzer
}

install_uv() {
  curl -LsSf https://astral.sh/uv/install.sh | sh
}

install_lua() {
  INSTALL_PREFIX="$HOME/.local/share/lua"

  for cmd in curl make gcc unzip; do
    if ! command -v "$cmd" >/dev/null; then
      error "$cmd is required but not installed."
      exit 1
    fi
  done

  # Fetch latest Lua version dynamically
  log "Fetching latest Lua version"
  LUA_PAGE=$(curl -s https://www.lua.org/ftp/)
  LUA_VERSION=$(echo "$LUA_PAGE" | grep -oP 'lua-\K[0-9]+\.[0-9]+\.[0-9]+(?=\.tar\.gz)' | sort -V | tail -n 1)

  if [ -z "$LUA_VERSION" ]; then
    error "Failed to detect latest Lua version"
    exit 1
  fi

  LUA_FULL="lua-${LUA_VERSION}"
  LUA_TAR="${LUA_FULL}.tar.gz"
  LUA_URL="https://www.lua.org/ftp/${LUA_TAR}"

  log "Downloading Lua $LUA_VERSION"
  curl -R -O "$LUA_URL"

  log "Extracting Lua"
  tar -zxf "$LUA_TAR"
  cd "$LUA_FULL"

  log "Building Lua"
  make linux
  make INSTALL_TOP="$INSTALL_PREFIX" install
  cd ..
  rm -rf "$LUA_FULL" "$LUA_TAR"

  # Get latest LuaRocks version from luarocks.org/releases
  log "Fetching latest LuaRocks version"
  LUAROCKS_VERSION=$(curl -s -L https://luarocks.org/releases/ | grep -oP 'luarocks-\K[0-9]+\.[0-9]+\.[0-9]+(?=\.tar\.gz)' | sort -V | tail -n 1)

  if [ -z "$LUAROCKS_VERSION" ]; then
    error "Failed to detect latest LuaRocks version"
    exit 1
  fi

  LUAROCKS_FULL="luarocks-${LUAROCKS_VERSION}"
  LUAROCKS_TAR="${LUAROCKS_FULL}.tar.gz"
  LUAROCKS_URL="https://luarocks.org/releases/${LUAROCKS_TAR}"

  log "Downloading LuaRocks $LUAROCKS_VERSION"
  curl -L -O "$LUAROCKS_URL"
  tar -zxf "$LUAROCKS_TAR"
  cd "$LUAROCKS_FULL" || exit

  log "Installing LuaRocks"
  ./configure --prefix="$INSTALL_PREFIX" --with-lua="$INSTALL_PREFIX"
  make
  make install
  cd ..
  rm -rf "$LUAROCKS_FULL" "$LUAROCKS_TAR"

  log "Verifying Lua installation"
  lua -v || {
    error "Lua installation failed"
    exit 1
  }

  log "Verifying LuaRocks installation"
  luarocks --version || {
    error "LuaRocks installation failed"
    exit 1
  }

  log "Lua $LUA_VERSION and LuaRocks $LUAROCKS_VERSION installed successfully"
}

install_languages() {
  install_go
  install_fnm
  install_rust
  install_uv
  install_lua
}
