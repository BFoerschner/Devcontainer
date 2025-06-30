#!/usr/bin/env bash
set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR"/init_scripts/logging.sh

export GOPATH="$HOME/.local/gopkg"
# Pre-populate PATH so we don't have to do it later
export PATH="/usr/bin/:$PATH"
export PATH="/usr/local/bin/:$PATH"
export PATH="$HOME/.local/share/fnm:$PATH"
export PATH="$HOME/.local/share/go/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.local/share/lua/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

log "update os"
"$SCRIPT_DIR"/init_scripts/update_os.sh -y

log "install golang"
"$SCRIPT_DIR"/init_scripts/go.sh

log "install rust toolchain"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
rustup component add rust-analyzer

log "install uv"
curl -LsSf https://astral.sh/uv/install.sh | sh

log "install fnm and node"
curl -fsSL https://fnm.vercel.app/install | bash
eval "$(fnm env)"
fnm install --latest

log "install lua"
"$SCRIPT_DIR"/init_scripts/lua.sh

log "install oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | bash -s

log "install dotfiles for cozy dev environment"
[ -d "$HOME"/.dotfiles ] && rm -rf "$HOME"/.dotfiles
[ -f "$HOME"/.zshrc ] && rm "$HOME"/.zshrc
git clone https://github.com/BFoerschner/dotfiles "$HOME"/.dotfiles
cd "$HOME"/.dotfiles
stow .
cd "$HOME"

log "install and setup neovim"
"$SCRIPT_DIR"/init_scripts/neovim.sh
"$SCRIPT_DIR"/init_scripts/neovim_setup.sh

log "installing tools"
go install github.com/zyedidia/eget@latest
go install github.com/jesseduffield/lazydocker@latest
go install github.com/jesseduffield/lazygit@latest
go install github.com/itchyny/mmv/cmd/mmv@latest
go install github.com/maaslalani/nap@main
go install github.com/junegunn/fzf@latest
go install github.com/muesli/duf@latest
go install github.com/wagoodman/dive@latest
go install github.com/mikefarah/yq/v4@latest
go install github.com/direnv/direnv@latest
go install code.gitea.io/tea@v0.10.1

uv tool install 'harlequin[postgres,mysql,s3]' --force
uv tool install 'httpie' --force
uv tool install 'jrnl' --force
uv tool install 'keymap-drawer' --force
uv tool install 'llm' --force
uv tool install 'go-task-bin' --force
uv tool install 'visidata' --force
uv tool install 'mitmproxy' --force
uv tool install 'ansible' --force
uv tool install 'ansible-core' --force

cargo install bat
cargo install eza
cargo install fd-find
cargo install hurl
cargo install git-delta
cargo install ripgrep
cargo install du-dust
cargo install termscp
cargo install silicon

"$SCRIPT_DIR"/init_scripts/pass_otp.sh
"$SCRIPT_DIR"/init_scripts/terraform.sh
"$SCRIPT_DIR"/init_scripts/tmux.sh
"$SCRIPT_DIR"/init_scripts/docker.sh
"$SCRIPT_DIR"/init_scripts/tmux_xpanes.sh
"$SCRIPT_DIR"/init_scripts/kubectl.sh

REPOS=(
  "jgm/pandoc"
  "cli/cli" # github cli
)
for repo in "${REPOS[@]}"; do
  log "Installing $repo..."
  if eget "$repo" --to "$HOME/.local/bin" --asset ^musl --asset ^libgit --asset .tar.gz; then
    log "Successfully installed $repo"
  else
    error "Failed to install $repo"
    exit 1
  fi
done

ln -s "$HOME"/.cargo/bin/dust "$HOME"/.local/bin/du
ln -s /usr/bin/duf "$HOME"/.local/bin/df

log "changing default shell to zsh"
chsh -s /bin/zsh root

log "pre-installing zsh plugins and generating cache"
"$SCRIPT_DIR"/init_scripts/zsh_init.sh

log "clean up go cache"
go clean -cache
go clean -modcache
log "clean up uv cache"
uv cache clean
log "clean up cargo cache"
[ -d "$HOME"/.cargo/registry ] && rm -rf "$HOME"/.cargo/registry
