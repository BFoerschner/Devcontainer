#!/usr/bin/env bash
# shellcheck source-path=./build-scripts
set -eo pipefail
BUILD_SCRIPTS_DIR="/root/build-scripts"

source "$BUILD_SCRIPTS_DIR"/logging.sh
source "$BUILD_SCRIPTS_DIR"/common_setup.sh
source "$BUILD_SCRIPTS_DIR"/update_os.sh
source "$BUILD_SCRIPTS_DIR"/languages.sh
source "$BUILD_SCRIPTS_DIR"/dotfiles.sh
source "$BUILD_SCRIPTS_DIR"/go_tools.sh
source "$BUILD_SCRIPTS_DIR"/uv_tools.sh
source "$BUILD_SCRIPTS_DIR"/cargo_tools.sh
source "$BUILD_SCRIPTS_DIR"/npm_tools.sh
source "$BUILD_SCRIPTS_DIR"/tools.sh
source "$BUILD_SCRIPTS_DIR"/cleanup_caches.sh

setup_environment

update_os true
install_languages
install_dotfiles
install_go_tools
install_uv_tools
install_cargo_tools
install_npm_tools
install_tools

cleanup_caches

log "changing default shell to bash"
log "default shell for tmux will be nu still"
chsh -s /bin/bash root
