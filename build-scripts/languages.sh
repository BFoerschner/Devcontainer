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

  # Create temporary directory for downloads
  TEMP_DIR=$(mktemp -d)
  cd "$TEMP_DIR" || {
    error "Failed to create temporary directory"
    exit 1
  }

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
  cd "$LUA_FULL" || {
    error "Failed to enter Lua source directory $LUA_FULL"
    exit 1
  }

  log "Building Lua"
  make linux
  make INSTALL_TOP="$INSTALL_PREFIX" install
  cd "$TEMP_DIR"

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
  cd "$LUAROCKS_FULL" || {
    error "Failed to enter LuaRocks source directory $LUAROCKS_FULL"
    exit 1
  }

  log "Installing LuaRocks"
  ./configure --prefix="$INSTALL_PREFIX" --with-lua="$INSTALL_PREFIX"
  make
  make install

  # Clean up temporary directory
  cd /
  rm -rf "$TEMP_DIR"

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

install_java_lts() {
  # Install dependencies
  sudo apt-get update
  sudo apt-get install -y wget apt-transport-https gpg curl jq

  # Get latest LTS version from Adoptium API
  LTS_VERSION=$(curl -s https://api.adoptium.net/v3/info/available_releases | jq -r '.available_lts_releases[-1]')
  log "Latest LTS version: $LTS_VERSION"

  # Get codename and check if supported
  CODENAME=$(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release)
  if ! curl -sf "https://packages.adoptium.net/artifactory/deb/dists/${CODENAME}/Release" >/dev/null 2>&1; then
    log "Codename '$CODENAME' not supported, using 'jammy' repository"
    CODENAME="jammy"
  fi

  # Add Adoptium repository
  wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/adoptium.gpg >/dev/null
  echo "deb https://packages.adoptium.net/artifactory/deb $CODENAME main" | sudo tee /etc/apt/sources.list.d/adoptium.list

  # Install latest LTS JDK
  sudo apt-get update
  sudo apt-get install -y temurin-"${LTS_VERSION}"-jdk

  # Set JAVA_HOME
  java_path=$(update-alternatives --list java | grep temurin | head -n 1)
  java_home=$(dirname $(dirname $java_path))
  echo "JAVA_HOME=$java_home" >>/etc/environment
  echo "export JAVA_HOME=$java_home" >/etc/profile.d/java_home.sh
  echo "export PATH=\$PATH:\$JAVA_HOME/bin" >>/etc/profile.d/java_home.sh

  log "JDK $LTS_VERSION LTS installed. Run: source /etc/profile.d/java_home.sh"
}

install_maven() {
  MAVEN_VERSION=$(curl -s https://api.github.com/repos/apache/maven/releases/latest | grep -Po '"tag_name": "maven-\K[^"]*')

  # Create temp directory for download
  TEMP_DIR=$(mktemp -d)
  cd "$TEMP_DIR" || exit 1

  log "Downloading Maven ${MAVEN_VERSION}"
  wget -q "https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" || {
    error "Failed to download Maven"
    exit 1
  }

  log "Extracting Maven to /usr/local"
  sudo tar -xzf apache-maven-"${MAVEN_VERSION}"-bin.tar.gz -C /usr/local || {
    error "Failed to extract Maven"
    exit 1
  }

  # Verify extraction
  if [ ! -d "/usr/local/apache-maven-${MAVEN_VERSION}" ]; then
    error "Maven directory not found after extraction"
    exit 1
  fi

  log "Creating Maven symlink"
  sudo ln -sf /usr/local/apache-maven-"${MAVEN_VERSION}"/bin/mvn /usr/local/bin/mvn || {
    error "Failed to create Maven symlink"
    exit 1
  }

  # Clean up
  cd /
  rm -rf "$TEMP_DIR"

  # Verify installation
  if ! /usr/local/bin/mvn --version >/dev/null 2>&1; then
    error "Maven installation verification failed"
    exit 1
  fi

  log "Maven ${MAVEN_VERSION} installed successfully"
}

install_languages() {
  install_go
  install_fnm
  install_rust
  install_uv
  install_lua
  install_java_lts
  install_maven
}
