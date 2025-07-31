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
install_starship
cargo install nu
cleanup_caches

log "changing default shell to zsh"
echo "/root/.cargo/bin/nu" >>/etc/shells
chsh -s /root/.cargo/bin/nu root
