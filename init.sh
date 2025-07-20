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

# Go tools
log "Installing Go tools..."
log "eget: Simple binary downloader"
go install github.com/zyedidia/eget@latest

log "lazydocker: Docker container management TUI"
go install github.com/jesseduffield/lazydocker@latest

log "lazygit: Git repository management TUI"
go install github.com/jesseduffield/lazygit@latest

log "mmv: Multi-file renaming tool"
go install github.com/itchyny/mmv/cmd/mmv@latest

log "nap: Code snippet manager"
go install github.com/maaslalani/nap@main

log "fzf: Fuzzy finder"
go install github.com/junegunn/fzf@latest

log "duf: Disk usage utility"
go install github.com/muesli/duf@latest

log "dive: Docker image layer explorer"
go install github.com/wagoodman/dive@latest

log "yq: YAML processor"
go install github.com/mikefarah/yq/v4@latest

log "direnv: Environment variable manager"
go install github.com/direnv/direnv@latest

log "tea: Gitea CLI client"
go install code.gitea.io/tea@v0.10.1

# UV tools
log "Installing UV tools..."
log "harlequin: SQL IDE with database support"
uv tool install 'harlequin[postgres,mysql,s3]' --force

log "httpie: HTTP client"
uv tool install 'httpie' --force

log "jrnl: Command-line journal"
uv tool install 'jrnl' --force

log "llm: Large Language Model CLI"
uv tool install 'llm' --force

log "go-task-bin: Task runner"
uv tool install 'go-task-bin' --force

log "visidata: Data exploration tool"
uv tool install 'visidata' --force

log "mitmproxy: HTTP proxy for testing"
uv tool install 'mitmproxy' --force

log "ansible: IT automation platform"
uv tool install 'ansible' --force

log "ansible-core: Ansible core components"
uv tool install 'ansible-core' --force

# Cargo tools
log "Installing Cargo tools..."
log "bat: Cat clone with syntax highlighting"
cargo install bat

log "eza: Modern ls replacement"
cargo install eza

log "fd-find: Fast find alternative"
cargo install fd-find

log "hurl: HTTP testing tool"
# cargo install hurl

log "git-delta: Git diff viewer"
cargo install git-delta

log "ripgrep: Fast grep alternative"
cargo install ripgrep

log "du-dust: Disk usage analyzer"
cargo install du-dust

log "termscp: Terminal file transfer"
cargo install termscp

log "silicon: Code screenshot generator"
cargo install silicon

log "procs: replacement for ps"
cargo install procs

# Install npm tools
log "claude code: Anthropic agentic llm"
npm install -g @anthropic-ai/claude-code

# other installscripts
log "pass-otp (OTP extension for pass password manager)"
"$SCRIPT_DIR"/init_scripts/pass_otp.sh

log "terraform (Infrastructure as Code tool)"
"$SCRIPT_DIR"/init_scripts/terraform.sh

log "tmux (Terminal multiplexer)"
"$SCRIPT_DIR"/init_scripts/tmux.sh

log "tmux-xpanes (Tmux pane management)"
"$SCRIPT_DIR"/init_scripts/tmux_xpanes.sh

log "docker (Container platform)"
"$SCRIPT_DIR"/init_scripts/docker.sh

log "kubectl (Kubernetes CLI)"
"$SCRIPT_DIR"/init_scripts/kubectl.sh

log "Tool installation complete!"

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
