#!/bin/bash

mkdir -p "$HOME/.local/bin"
cd "$HOME/.local/bin" || exit

for script in ~/init_scripts/*.sh; do
  echo "Executing $script"
  "$script"
done
