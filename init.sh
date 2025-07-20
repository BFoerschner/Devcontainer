#!/usr/bin/env bash
set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "$SCRIPT_DIR"

source "$SCRIPT_DIR"/init_scripts/logging.sh
source "$SCRIPT_DIR"/build-scripts/common_setup.sh
source "$SCRIPT_DIR"/build-scripts/go_tools.sh
source "$SCRIPT_DIR"/build-scripts/uv_tools.sh
source "$SCRIPT_DIR"/build-scripts/cargo_tools.sh
source "$SCRIPT_DIR"/build-scripts/npm_tools.sh
source "$SCRIPT_DIR"/build-scripts/other_tools.sh
source "$SCRIPT_DIR"/build-scripts/cleanup_caches.sh

setup_environment
install_go_tools
install_uv_tools
install_cargo_tools
install_npm_tools
install_other_tools
cleanup_caches

log "Tool installation complete!"

log "changing default shell to zsh"
chsh -s /bin/zsh root
