#!/usr/bin/env zsh
# Fail fast
set -euo pipefail

export ZDOTDIR="${ZDOTDIR:-$HOME}"
export ZSHRC_FORCE_LOAD=1 # Override non-interactive early return

# Source your actual zshrc
source "$ZDOTDIR/.zshrc"

# Force compinit and dump file generation
autoload -Uz compinit
compinit -i

[[ -f "${ZDOTDIR}/.zcompdump" ]] && zcompile "${ZDOTDIR}/.zcompdump"

#!/usr/bin/env zsh
echo "ZSH completion-cache successfully generated"
