#!/usr/bin/env bash
set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR"/logging.sh

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

git clone https://github.com/tadfisher/pass-otp
cd pass-otp
if ((EUID == 0)); then
  make install
else
  sudo make install
fi
