#!/usr/bin/env zsh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/logging.sh

curl -sS https://starship.rs/install.sh | zsh -s -- -y
export ZSHRC_FORCE_LOAD=1

log "Initializing Zsh environment"

source ~/.zshrc # sourcing the file should do the trick

zinit update
