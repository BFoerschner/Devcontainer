#!/usr/bin/env bash

setup_environment() {
  export GOPATH="$HOME/.local/gopkg"
  export PATH="/usr/bin/:$PATH"
  export PATH="/usr/local/bin/:$PATH"
  export PATH="$HOME/.local/share/fnm:$PATH"
  export PATH="$HOME/.local/share/go/bin:$PATH"
  export PATH="$GOPATH/bin:$PATH"
  export PATH="$HOME/.local/share/lua/bin:$PATH"
  export PATH="$HOME/.cargo/bin:$PATH"
  export PATH="$HOME/.local/bin:$PATH"

  export KUBE_EDITOR=nvim
  # if fnm exists, use it
  if command -v fnm &>/dev/null; then
    eval "$(fnm env)" 2>/dev/null
  fi
}
