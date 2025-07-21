#!/usr/bin/env bash
set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Handle case where script is in root directory (Docker container)
if [[ "$SCRIPT_DIR" == "/root" ]]; then
    BUILD_SCRIPTS_DIR="/root/build-scripts"
else
    BUILD_SCRIPTS_DIR="$(dirname "$SCRIPT_DIR")/build-scripts"
fi
source "$BUILD_SCRIPTS_DIR"/logging.sh

export GOPATH="$HOME/.local/gopkg"
# Pre-populate PATH so we don't have to do it later
export PATH="/usr/bin/:$PATH"
export PATH="/usr/local/bin/:$PATH"
export PATH="$HOME/.local/share/fnm:$PATH"
export PATH="$HOME/.local/share/go/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.local/share/lua/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

log "update os"
"$BUILD_SCRIPTS_DIR"/update_os.sh -y

log "install golang"
"$BUILD_SCRIPTS_DIR"/go.sh

log "install rust toolchain"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
rustup component add rust-analyzer

log "install uv"
curl -LsSf https://astral.sh/uv/install.sh | sh

log "install fnm and node"
curl -fsSL https://fnm.vercel.app/install | bash
eval "$(fnm env)"
fnm install --latest

log "install lua"
"$BUILD_SCRIPTS_DIR"/lua.sh

log "install starship"
curl -sS https://starship.rs/install.sh | sh -s -- -y

log "install dotfiles for cozy dev environment"
[ -d "$HOME"/.dotfiles ] && rm -rf "$HOME"/.dotfiles
[ -f "$HOME"/.zshrc ] && rm "$HOME"/.zshrc
git clone https://github.com/BFoerschner/dotfiles "$HOME"/.dotfiles
cd "$HOME"/.dotfiles
stow .
cd "$HOME"
