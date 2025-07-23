#!/usr/bin/env bash
# shellcheck source-path=./build-scripts
set -eo pipefail
BUILD_SCRIPTS_DIR="/root/build-scripts"

source "$BUILD_SCRIPTS_DIR"/logging.sh
source "$BUILD_SCRIPTS_DIR"/common_setup.sh
source "$BUILD_SCRIPTS_DIR"/cleanup_caches.sh
source "$BUILD_SCRIPTS_DIR"/tools.sh
source "$BUILD_SCRIPTS_DIR"/dotfiles.sh

setup_environment

install_starship
install_dotfiles
install_neovim
install_neovim_plugins

cleanup_caches

log "changing default shell to zsh"
chsh -s /bin/zsh root
