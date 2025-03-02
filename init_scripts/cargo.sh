#!/usr/bin/env bash

/root/.cargo/bin/cargo install \
  eza \
  du-dust

ln -s /usr/bin/dust ~/.local/bin/du
