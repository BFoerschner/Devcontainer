#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/logging.sh

# Use sudo only if not running as root
if [ "$EUID" -ne 0 ]; then
  PRIVILEGE="sudo"
else
  PRIVILEGE=""
fi

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
$PRIVILEGE make INSTALL_TOP="$INSTALL_PREFIX" install
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
cd "$LUAROCKS_FULL"

log "Installing LuaRocks"
./configure --prefix="$INSTALL_PREFIX" --with-lua="$INSTALL_PREFIX"
make
$PRIVILEGE make install
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
