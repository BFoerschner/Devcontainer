#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/logging.sh

TMPDIR=$(mktemp -d)

eget tmux/tmux --download-only --to "$TMPDIR/tmux.tar.gz"
cd "$TMPDIR"
echo "$TMPDIR"

TAR_OUTPUT=$(tar -tzf "$TMPDIR"/tmux.tar.gz) || {
  echo "Failed to list contents of tarball" >&2
  exit 1
}
echo "$TAR_OUTPUT"
TMUX_SOURCE_DIR=$(echo "$TAR_OUTPUT" | head -n1 | cut -f1 -d'/')
tar -xzf "$TMPDIR"/tmux.tar.gz
cd "$TMUX_SOURCE_DIR"

./configure && make
if ((EUID == 0)); then
  make install
else
  sudo make install
fi

cd "$HOME"
rm -rf "$TMPDIR"

TPM_PLUGINS_DIR="$HOME"/.config/tmux/plugins/tpm

[ -d "$TPM_PLUGINS_DIR" ] && rm -rf "$TPM_PLUGINS_DIR"
git clone https://github.com/tmux-plugins/tpm "$TPM_PLUGINS_DIR"
"$TPM_PLUGINS_DIR"/scripts/install_plugins.sh
