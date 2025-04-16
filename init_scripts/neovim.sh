#!/usr/bin/env bash

SLEEP_SECONDS=60

nvim --headless '+Lazy install' +q
npm install -g neovim
mkdir "$HOME/.venvs" && python3 -m venv "$HOME/.venvs/.nvim-venv"
source "$HOME/.venvs/.nvim-venv/bin/activate" && python3 -m pip install pynvim neovim

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
  "ruff"
)
MASON_DEPS="{$(printf "'%s', " "${LSP_CFG[@]}")}"
nvim --headless -c "lua require('mason').setup()" -c "lua require('mason.api.command').MasonInstall($MASON_DEPS)" -c "quitall"
nvim --headless -c "TSInstall all" -c "sleep $SLEEP_SECONDS" -c "quitall"
