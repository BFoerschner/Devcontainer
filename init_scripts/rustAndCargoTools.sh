#!/usr/bin/env bash

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

source $HOME/.cargo/env
cargo install eza
cargo install du-dust
