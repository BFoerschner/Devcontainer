#!/usr/bin/env bash
set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "$SCRIPT_DIR"

# Handle case where script is in root directory (Docker container)
if [[ "$SCRIPT_DIR" == "/root" ]]; then
    BUILD_SCRIPTS_DIR="/root/build-scripts"
else
    BUILD_SCRIPTS_DIR="$(dirname "$SCRIPT_DIR")/build-scripts"
fi

source "$BUILD_SCRIPTS_DIR"/logging.sh
source "$BUILD_SCRIPTS_DIR"/common_setup.sh
source "$BUILD_SCRIPTS_DIR"/go_tools.sh
source "$BUILD_SCRIPTS_DIR"/uv_tools.sh
source "$BUILD_SCRIPTS_DIR"/cargo_tools.sh
source "$BUILD_SCRIPTS_DIR"/npm_tools.sh
source "$BUILD_SCRIPTS_DIR"/other_tools.sh
source "$BUILD_SCRIPTS_DIR"/cleanup_caches.sh

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
