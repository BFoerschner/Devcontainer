#!/usr/bin/env bash
set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR"/logging.sh

# install python packages for neovim
# shellcheck disable=SC1091
log "installing python"
uv python install
log "creating neovims venv"
uv venv ~/.venvs/.nvim-venv
log "installing neovim python libs"
uv pip install -p ~/.venvs/.nvim-venv/bin/python pynvim neovim
log "setting up neovim node libs"
npm install -g neovim

# opening neovim and giving it time to install all the stuff
# 2 minutes *should* be enough
SLEEP_SECONDS=160

set +e          # Disable exit on error
set +o pipefail # Disable pipefail
nvim --headless '+Lazy install' +q
LSP_CFG=(
  "docker-compose-language-service"
  "tailwindcss-language-server"
  "dockerfile-language-server"
  "yaml-language-server"
  "bash-language-server"
  "vue-language-server"
  "lua-language-server"
  "markdownlint-cli2"
  "js-debug-adapter"
  "terraform-ls"
  "markdown-toc"
  "shellcheck"
  "eslint-lsp"
  "goimports"
  "prettier"
  "marksman"
  "json-lsp"
  "hadolint"
  "codelldb"
  "pyright"
  "lemminx"
  "gofumpt"
  "tflint"
  "stylua"
  "vtsls"
  "shfmt"
  "gopls"
  "delve"
  "black"
)
MASON_DEPS="{$(printf "'%s', " "${LSP_CFG[@]}")}"
nvim --headless -c "lua require('mason').setup()" -c "lua require('mason.api.command').MasonInstall($MASON_DEPS)" -c "quitall"
nvim --headless -c "TSInstall all" -c "sleep $SLEEP_SECONDS" -c "quitall"
