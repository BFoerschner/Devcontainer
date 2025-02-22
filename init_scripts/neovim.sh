#!/bin/bash

nvim --headless '+Lazy install' +q
npm install -g neovim
mkdir "$HOME/venvs" &&
  python3 -m venv "$HOME/venvs/.nvim-venv"
source "$HOME/venvs/.nvim-venv/bin/activate" && python3 -m pip install pynvim neovim
