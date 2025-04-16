#!/usr/bin/env bash

"$HOME"/.cargo/bin/cargo install du-dust

ln -s "$HOME"/.cargo/bin/dust "$HOME"/.local/bin/du
