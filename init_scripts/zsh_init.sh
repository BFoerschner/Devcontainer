#!/usr/bin/env zsh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/logging.sh

export ZSHRC_FORCE_LOAD=1

log "Initializing Zsh environment"
source ~/.zshrc # sourcing the file should do the trick

# run a command to ensure zinit has really loaded all the plugins
log "Verifying Zinit plugins"
zinit report

log "Zsh initialization complete"
