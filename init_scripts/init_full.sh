#!/usr/bin/env bash
# shellcheck source-path=./build-scripts
set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_SCRIPTS_DIR="$SCRIPT_DIR/build-scripts"

source "$BUILD_SCRIPTS_DIR"/logging.sh
source "$BUILD_SCRIPTS_DIR"/common_setup.sh
source "$BUILD_SCRIPTS_DIR"/go_tools.sh
source "$BUILD_SCRIPTS_DIR"/uv_tools.sh
source "$BUILD_SCRIPTS_DIR"/cargo_tools.sh
source "$BUILD_SCRIPTS_DIR"/npm_tools.sh
source "$BUILD_SCRIPTS_DIR"/tools.sh
source "$BUILD_SCRIPTS_DIR"/cleanup_caches.sh

setup_environment

install_go_tools
install_uv_tools
install_cargo_tools
install_npm_tools
install_tools

cleanup_caches

log "changing default shell to zsh"
chsh -s /bin/zsh root
