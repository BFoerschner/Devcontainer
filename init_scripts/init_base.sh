#!/usr/bin/env bash
# shellcheck source-path=./build-scripts
set -eo pipefail
BUILD_SCRIPTS_DIR="/root/build-scripts"

source "$BUILD_SCRIPTS_DIR"/logging.sh
source "$BUILD_SCRIPTS_DIR"/common_setup.sh
source "$BUILD_SCRIPTS_DIR"/cleanup_caches.sh
source "$BUILD_SCRIPTS_DIR"/update_os.sh
source "$BUILD_SCRIPTS_DIR"/languages.sh
source "$BUILD_SCRIPTS_DIR"/dotfiles.sh

setup_environment

update_os true # true = script is running inside a container
install_languages
install_dotfiles

cleanup_caches

log "changing default shell to zsh"
chsh -s /bin/zsh root
