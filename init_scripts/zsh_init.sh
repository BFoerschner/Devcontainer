#!/usr/bin/env zsh
# Disable safeguards as zinit got some unthrown errors in it
set +e
set +o pipefail

export ZDOTDIR="${ZDOTDIR:-$HOME}"
export ZSHRC_FORCE_LOAD=1 # Override non-interactive early return

source "$ZDOTDIR/.zshrc"

# Force compinit and dump file generation
autoload -Uz compinit
compinit -i

[[ -f "${ZDOTDIR}/.zcompdump" ]] && zcompile "${ZDOTDIR}/.zcompdump"

echo "ZSH completion-cache successfully generated"

set -eo pipefail # bring back failing on error
