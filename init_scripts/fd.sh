#!/usr/bin/env bash

apt-get install -y fd-find

ln -s /usr/bin/fdfind "$HOME"/.local/bin/fd
