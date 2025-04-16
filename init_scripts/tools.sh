#!/usr/bin/env bash

apt-get install -y \
  ripgrep \
  ncdu \
  direnv \
  duf \
  pass \
  pass-extension-otp

ln -s /usr/bin/duf ~/.local/bin/df
