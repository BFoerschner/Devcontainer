# Development Tools Documentation

This document provides comprehensive documentation for all tools installed inside the devcontainer. All tools are managed by [mise](https://mise.jdx.dev/) and configured in `.mise.toml`. Tools are compiled from source when feasible. The tools are well-documented and for the most part easy to learn.

## Quick Reference

### Programming Languages & Runtimes
| Tool | Purpose | Documentation |
| ---- | ------- | ------------- |
| [go](#go) | Go programming language | [Docs](https://go.dev/doc/) |
| [rust](#rust) | Rust programming language | [Docs](https://www.rust-lang.org/learn) |
| [node](#node) | Node.js JavaScript runtime | [Docs](https://nodejs.org/docs/) |
| [lua](#lua) | Lua scripting language | [Docs](https://www.lua.org/docs.html) |
| [java](#java) | Java Development Kit | [Docs](https://docs.oracle.com/en/java/) |

### Build Tools & Package Managers
| Tool | Purpose | Documentation |
| ---- | ------- | ------------- |
| [uv](#uv) | Ultra-fast Python package installer | [Docs](https://github.com/astral-sh/uv) |
| [maven](#maven) | Java build automation tool | [Docs](https://maven.apache.org/guides/) |
| [pipx](#pipx) | Install Python apps in isolated environments | [Docs](https://pipx.pypa.io/) |
| [just](#just) | Command runner | [Docs](https://just.systems/man/en/) |

### File & Text Tools
| Tool | Purpose | Documentation |
| ---- | ------- | ------------- |
| [eza](#eza) | Modern `ls` with icons and git status | [Docs](https://eza.rocks/) |
| [fd](#fd) | Fast alternative to `find` | [Docs](https://github.com/sharkdp/fd#how-to-use) |
| [fzf](#fzf) | Fuzzy finder for files and commands | [Docs](https://github.com/junegunn/fzf#usage) |
| [bat](#bat) | Syntax-highlighted file viewer | [Docs](https://github.com/sharkdp/bat#how-to-use) |
| [ripgrep](#ripgrep) | Ultra-fast text search | [Docs](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md) |
| [choose](#choose) | Human-friendly `cut` alternative | [Docs](https://github.com/theryangeary/choose) |
| [pandoc](#pandoc) | Universal document converter | [Docs](https://pandoc.org/) |
| [termscp](#termscp) | Terminal file transfer client | [Docs](https://termscp.veeso.dev/) |

### System Monitoring & Process Tools
| Tool | Purpose | Documentation |
| ---- | ------- | ------------- |
| [procs](#procs) | Modern `ps` replacement | [Docs](https://github.com/dalance/procs#usage) |
| [du-dust](#du-dust) | Better disk usage analyzer | [Docs](https://github.com/bootandy/dust#usage) |
| [duf](#duf) | Modern `df` with better output | [Docs](https://github.com/muesli/duf#usage) |

### Git Tools
| Tool | Purpose | Documentation |
| ---- | ------- | ------------- |
| [lazygit](#lazygit) | Terminal UI for Git | [Docs](https://github.com/jesseduffield/lazygit#usage) |
| [delta](#delta) | Better git diff viewer | [Docs](https://dandavison.github.io/delta/) |
| [gh](#gh) | GitHub CLI | [Docs](https://cli.github.com/manual/) |
| [difftastic](#difftastic) | Structural diff tool | [Docs](https://difftastic.wilfred.me.uk/) |

### Container & Infrastructure Tools
| Tool | Purpose | Documentation |
| ---- | ------- | ------------- |
| [lazydocker](#lazydocker) | Terminal UI for Docker | [Docs](https://github.com/jesseduffield/lazydocker#usage) |
| [dive](#dive) | Analyze Docker image layers | [Docs](https://github.com/wagoodman/dive) |
| [docker-cli](#docker-cli) | Docker command-line interface | [Docs](https://docs.docker.com/reference/cli/docker/) |
| [docker-compose](#docker-compose) | Multi-container Docker applications | [Docs](https://docs.docker.com/compose/) |
| [kubectl](#kubectl) | Kubernetes CLI | [Docs](https://kubernetes.io/docs/reference/kubectl/) |
| [k9s](#k9s) | Kubernetes CLI dashboard | [Docs](https://k9scli.io/) |
| [terraform](#terraform) | Infrastructure as Code | [Docs](https://developer.hashicorp.com/terraform/docs) |

### Development Environment
| Tool | Purpose | Documentation |
| ---- | ------- | ------------- |
| [neovim](#neovim) | Advanced text editor | [Docs](https://neovim.io/doc/) |
| [vim](#vim) | Classic text editor | [Docs](https://www.vim.org/docs.php) |
| [tmux](#tmux) | Terminal multiplexer | [Docs](https://man7.org/linux/man-pages/man1/tmux.1.html) |
| [starship](#starship) | Cross-shell prompt | [Docs](https://starship.rs/guide/) |
| [direnv](#direnv) | Per-directory environment variables | [Docs](https://github.com/direnv/direnv#docs) |
| [zoxide](#zoxide) | Smart directory jumper | [Docs](https://github.com/ajeetdsouza/zoxide#configuration) |

### Data & Configuration Tools
| Tool | Purpose | Documentation |
| ---- | ------- | ------------- |
| [yq](#yq) | YAML/JSON processor | [Docs](https://mikefarah.gitbook.io/yq/) |
| [jq](#jq) | JSON processor | [Docs](https://jqlang.github.io/jq/manual/) |
| [sops](#sops) | Encrypted secrets management | [Docs](https://github.com/getsops/sops) |
| [harlequin](#harlequin) | Terminal SQL IDE | [Docs](https://harlequin.sh/docs/getting-started/index) |
| [visidata](#visidata) | Terminal spreadsheet | [Docs](https://visidata.org/docs/) |

### Network & API Tools
| Tool | Purpose | Documentation |
| ---- | ------- | ------------- |
| [httpie](#httpie) | User-friendly HTTP client | [Docs](https://httpie.io/docs/cli) |
| [mitmproxy](#mitmproxy) | Interactive HTTPS proxy | [Docs](https://docs.mitmproxy.org/stable/) |

### DevOps & Automation
| Tool | Purpose | Documentation |
| ---- | ------- | ------------- |
| [ansible](#ansible) | IT automation platform | [Docs](https://docs.ansible.com/) |
| [claude-code](#claude-code) | AI-powered code assistant | [Docs](https://docs.anthropic.com/en/docs/claude-code/overview) |

### Utilities
| Tool | Purpose | Documentation |
| ---- | ------- | ------------- |
| [silicon](#silicon) | Create beautiful code screenshots | [Docs](https://github.com/Aloxaf/silicon#examples) |
| [stringshift](#stringshift) | String transformation utility | [Docs](https://github.com/DevBullions/stringshift#quick-start) |
| [jrnl](#jrnl) | Command-line journaling | [Docs](https://jrnl.sh/en/latest/) |
| [nu](#nu) | Modern shell with structured data | [Docs](https://www.nushell.sh/book/) |
| [lnav](#lnav) | Log file navigator and analyzer | [Docs](https://docs.lnav.org/) |


---

## Programming Languages & Runtimes

### [go](https://go.dev/)
**Purpose**: Go programming language for building fast, reliable software

```bash
# Check version
go version

# Initialize module
go mod init myproject

# Build binary
go build

# Run program
go run main.go

# Install dependencies
go mod tidy

# Run tests
go test ./...
```

### [rust](https://www.rust-lang.org/)
**Purpose**: Systems programming language focused on safety and performance

```bash
# Check version
rustc --version
cargo --version

# Create new project
cargo new myproject

# Build project
cargo build

# Run project
cargo run

# Run tests
cargo test

# Build optimized release
cargo build --release
```

### [node](https://nodejs.org/)
**Purpose**: JavaScript runtime built on Chrome's V8 engine

```bash
# Check version
node --version
npm --version

# Initialize project
npm init

# Install dependencies
npm install

# Run script
npm run start

# Install package
npm install package-name
```

### [lua](https://www.lua.org/)
**Purpose**: Lightweight, embeddable scripting language

```bash
# Check version
lua -v

# Run script
lua script.lua

# Interactive REPL
lua
```

### [java](https://www.oracle.com/java/)
**Purpose**: Java Development Kit for building Java applications

```bash
# Check version
java -version
javac -version

# Compile Java file
javac MyProgram.java

# Run compiled class
java MyProgram

# Run JAR file
java -jar myapp.jar
```

## Build Tools & Package Managers

### [uv](https://github.com/astral-sh/uv)
**Purpose**: Ultra-fast Python package installer and resolver

```bash
# Install package
uv pip install requests

# Install from requirements
uv pip install -r requirements.txt

# Create virtual environment
uv venv

# Sync dependencies
uv pip sync requirements.txt
```

### [maven](https://maven.apache.org/)
**Purpose**: Build automation tool for Java projects

```bash
# Create new project
mvn archetype:generate

# Compile project
mvn compile

# Run tests
mvn test

# Package application
mvn package

# Clean build artifacts
mvn clean

# Install to local repository
mvn install
```

### [pipx](https://pipx.pypa.io/)
**Purpose**: Install and run Python applications in isolated environments

```bash
# Install application
pipx install package-name

# List installed apps
pipx list

# Upgrade application
pipx upgrade package-name

# Uninstall application
pipx uninstall package-name

# Run without installing
pipx run package-name
```

## File & Text Tools

### [eza](https://github.com/eza-community/eza)
**Purpose**: Modern replacement for `ls` with icons and git integration  


```bash
# Basic usage with icons
eza --icons

# Long format with git status
eza -l --git

# Tree view
eza --tree

# Sort by size/date
eza -l --sort=size
eza -l --sort=modified
```

### [fd](https://github.com/sharkdp/fd)
**Purpose**: Simple, fast alternative to `find`  


```bash
# Find files by name
fd pattern

# Find specific file types
fd -e rs -e py

# Execute command on results
fd -x rm {}

# Search hidden files
fd -H pattern
```

### [fzf](https://github.com/junegunn/fzf)
**Purpose**: Command-line fuzzy finder  


```bash
# Find files
fzf

# With preview
fzf --preview 'bat --color=always {}'

# Search history
history | fzf

# Integration
vim $(fzf)
```

### [bat](https://github.com/sharkdp/bat)
**Purpose**: Syntax-highlighted file viewer  


```bash
# View file with highlighting
bat file.py

# Show line numbers
bat -n file.js

# Use as pager
bat --paging=always large-file.log
```

### [termscp](https://github.com/veeso/termscp)
**Purpose**: Terminal file transfer client  


```bash
# Connect to remote server
termscp -a sftp://user@host

# Quick transfer
termscp -T /local/file user@host:/remote/path
```

### [ripgrep](https://github.com/BurntSushi/ripgrep)
**Purpose**: Extremely fast grep replacement  


```bash
# Basic search
rg pattern

# Search specific file types
rg -t py pattern

# Case insensitive
rg -i pattern

# With context
rg -C 3 pattern
```

### [choose](https://github.com/theryangeary/choose)
**Purpose**: Human-friendly alternative to `cut`  


```bash
# Select fields (0-indexed)
echo "one:two:three" | choose -f : 1

# Select ranges
echo "a b c d e" | choose 1:4

# From end
echo "a b c d e" | choose -1
```

### [pandoc](https://github.com/jgm/pandoc)
**Purpose**: Universal document converter  


```bash
# Convert Markdown to HTML
pandoc document.md -o document.html

# Convert to PDF
pandoc document.md -o document.pdf

# With custom styling
pandoc document.md -s --css=style.css -o document.html
```

### [silicon](https://github.com/Aloxaf/silicon)
**Purpose**: Create beautiful code screenshots  


```bash
# Generate from file
silicon main.rs -o output.png

# From clipboard
silicon --from-clipboard -o image.png

# With theme
silicon --theme Dracula main.rs -o output.png
```

### [procs](https://github.com/dalance/procs)
**Purpose**: Modern replacement for `ps`  


```bash
# Show all processes
procs

# Filter by name
procs rust

# Tree view
procs --tree

# Sort by CPU/memory
procs --sort cpu
```

### [du-dust](https://github.com/bootandy/dust)
**Purpose**: More intuitive version of `du` (aliased as `du`)  


```bash
# Show disk usage
dust
du  # alias

# Limit depth
dust -d 3

# Show percentages
dust -p
```

### [duf](https://github.com/muesli/duf)
**Purpose**: Better disk usage utility (aliased as `df`)  


```bash
# Show disk usage
duf
df  # alias

# Show only local filesystems
duf --only local

# JSON output
duf --json
```

### [lazygit](https://github.com/jesseduffield/lazygit)
**Purpose**: Terminal UI for Git operations  


```bash
# Launch in current repo
lazygit
```

**Key shortcuts**: `space` (stage), `c` (commit), `P` (push), `p` (pull), `b` (branch)

### [delta](https://github.com/dandavison/delta)
**Purpose**: Syntax-highlighted git diff viewer  


```bash
# Configure as git pager
git config --global core.pager delta
git config --global delta.side-by-side true
```

### [gh](https://github.com/cli/cli)
**Purpose**: GitHub CLI  


```bash
# Create repository
gh repo create myproject

# Create pull request
gh pr create --title "Feature" --body "Description"

# View issues
gh issue list
```

### [difftastic](https://github.com/Wilfred/difftastic)
**Purpose**: Structural diff tool that understands syntax  


```bash
# Compare files
difft file1.rs file2.rs

# Use as git difftool
git config --global diff.tool difftastic
```

### [lazydocker](https://github.com/jesseduffield/lazydocker)
**Purpose**: Terminal UI for Docker management  


```bash
# Launch lazydocker
lazydocker
```

**Key shortcuts**: `d` (delete), `e` (exec), `s` (start/stop), `r` (restart), `l` (logs)

### [dive](https://github.com/wagoodman/dive)
**Purpose**: Docker image layer analyzer  


```bash
# Analyze image
dive myimage:tag

# CI mode
dive --ci myimage:tag
```

### [docker-cli](https://github.com/docker/cli)
**Purpose**: Docker command-line interface for container management

```bash
# Run container
docker run -it ubuntu:latest

# Build image
docker build -t myapp .

# List containers
docker ps -a

# Stop container
docker stop container-id

# Remove container
docker rm container-id

# Pull image
docker pull nginx:latest

# View logs
docker logs container-id
```

### [docker-compose](https://docs.docker.com/compose/)
**Purpose**: Tool for defining and running multi-container Docker applications

```bash
# Start services
docker-compose up

# Start in detached mode
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild services
docker-compose build

# List running services
docker-compose ps

# Execute command in service
docker-compose exec service-name bash
```

### [kubectl](https://github.com/kubernetes/kubectl)
**Purpose**: Kubernetes CLI  


```bash
# Get pods
kubectl get pods

# Apply configuration
kubectl apply -f deployment.yaml

# View logs
kubectl logs -f pod-name
```

### [k9s](https://github.com/derailed/k9s)
**Purpose**: Kubernetes CLI dashboard with real-time monitoring  


```bash
# Launch k9s
k9s

# Connect to specific cluster
k9s --context my-cluster

# Use specific namespace
k9s -n my-namespace
```

**Key shortcuts**: `:` (command mode), `/` (filter), `d` (describe), `l` (logs), `e` (edit), `?` (help)

### [terraform](https://github.com/hashicorp/terraform)
**Purpose**: Infrastructure as Code  

```bash
# Initialize
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply
```

### [neovim](https://github.com/neovim/neovim)
**Purpose**: Extensible text editor


Pre-configured with:
- Lazy.nvim plugin manager
- LSP support for all languages
- Mason for tool management
- Treesitter syntax highlighting

```bash
# Start Neovim
nvim
nvim file.txt

# Plugin management
:Lazy install
:Mason
```

### [vim](https://www.vim.org/)
**Purpose**: Classic highly configurable text editor

```bash
# Start Vim
vim
vim file.txt

# Open multiple files
vim file1.txt file2.txt

# Open file at specific line
vim +42 file.txt

# Read-only mode
vim -R file.txt

# Diff mode
vim -d file1.txt file2.txt
```

**Basic commands**: `i` (insert), `:w` (save), `:q` (quit), `:wq` (save & quit), `/search` (search), `dd` (delete line)

### [tmux](https://github.com/tmux/tmux)
**Purpose**: Terminal multiplexer  


```bash
# Start session
tmux new-session -s mysession

# List sessions
tmux ls

# Attach
tmux attach -t mysession
```

**Key shortcuts** (Ctrl+b prefix): `c` (new window), `"` (horizontal split), `%` (vertical split)

### [starship](https://github.com/starship/starship)
**Purpose**: Cross-shell customizable prompt  

Features: Git status, language versions, cloud context, fast performance

```bash
# Configuration
~/.config/starship.toml
```

### [stringshift](https://github.com/DevBullions/stringshift)
**Purpose**: Advanced text encoding/decoding library with auto-detection and parallel processing

```bash
# CLI decoding
stringshift "%22Hello%20World%22"

# Decode Base64
stringshift "SGVsbG8="

# Encode to Base64
stringshift -e base64 "Hello World"

# Auto-detect encoding
stringshift --detect "encoded_text"
```

### [direnv](https://github.com/direnv/direnv)
**Purpose**: Environment variable management per directory  

```bash
# Allow .envrc
direnv allow

# Create environment
echo 'export API_KEY="secret"' > .envrc
```

### [harlequin](https://github.com/tconbeer/harlequin)
**Purpose**: Terminal-based SQL IDE  


```bash
# Connect to PostgreSQL
harlequin postgres://user:pass@host/db

# Connect to SQLite
harlequin database.db

# Multiple databases
harlequin db1.db postgres://host/db2
```

### [visidata](https://github.com/saulpw/visidata)
**Purpose**: Terminal spreadsheet multitool  

```bash
# Open CSV
vd data.csv

# Multiple formats
vd data.json database.db data.xlsx

# From URL
vd https://example.com/data.csv
```

### [httpie](https://github.com/httpie/httpie)
**Purpose**: User-friendly HTTP client  

```bash
# GET request
http GET api.example.com/users

# POST with JSON
http POST api.example.com/users name=John age:=29

# Authentication
http -a user:pass GET api.example.com/protected
```

### [mitmproxy](https://github.com/mitmproxy/mitmproxy)
**Purpose**: Interactive HTTPS proxy  

```bash
# Interactive proxy
mitmproxy

# Web interface
mitmweb

# Command line
mitmdump
```

### [claude-code](https://github.com/anthropics/claude-code)
**Purpose**: AI-powered code assistant  


```bash
# Interactive session
claude-code

# Single command
claude-code "explain this function" < function.js

# Help
claude-code --help
```


### [ansible](https://github.com/ansible/ansible)
**Purpose**: IT automation platform  

```bash
# Run playbook
ansible-playbook playbook.yml

# Ad-hoc command
ansible all -m ping

# Check inventory
ansible-inventory --list
```

### [just](https://github.com/casey/just)
**Purpose**: Command runner and build tool  


```bash
# Run default recipe
just

# List recipes
just --list

# Run specific recipe
just build
```

### [yq](https://github.com/mikefarah/yq)
**Purpose**: YAML/JSON/XML processor


```bash
# Read YAML value
yq '.key.subkey' file.yaml

# Update YAML
yq '.key = "new-value"' -i file.yaml

# Convert formats
yq -o json file.yaml
```

### [jq](https://jqlang.github.io/jq/)
**Purpose**: Lightweight and flexible command-line JSON processor

```bash
# Pretty print JSON
cat file.json | jq '.'

# Extract field
cat file.json | jq '.fieldName'

# Filter arrays
cat file.json | jq '.[] | select(.age > 30)'

# Transform data
cat file.json | jq '.items | map(.name)'

# Output raw strings
cat file.json | jq -r '.message'
```

### [sops](https://github.com/getsops/sops)
**Purpose**: Encrypted file editor for managing secrets

```bash
# Encrypt file
sops -e secrets.yaml > secrets.enc.yaml

# Decrypt and edit
sops secrets.enc.yaml

# Decrypt to stdout
sops -d secrets.enc.yaml

# Encrypt specific keys only
sops -e --encrypted-regex '^(password|apikey)$' config.yaml

# Use with age
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
sops -e file.yaml
```

### [jrnl](https://github.com/jrnl-org/jrnl)
**Purpose**: Command-line journaling  


```bash
# Add entry
jrnl Today I learned about Docker containers.

# View recent entries
jrnl -n 10

# Search entries
jrnl @work --from "last month"
```

### [nu](https://github.com/nushell/nushell)
**Purpose**: Modern shell with structured data  

```bash
# Start Nushell
nu

# Work with structured data
ls | where size > 1KB | sort-by modified

# JSON operations
open data.json | get items | length
```

### [zoxide](https://github.com/ajeetdsouza/zoxide)
**Purpose**: Smart directory jumper that learns your habits  

```bash
# Jump to directory (after some usage)
z documents
z proj

# Add current directory to database
zoxide add .

# Remove directory from database
zoxide remove /path/to/dir

# Query database
zoxide query web

# Interactive selection
zi

# Edit database
zoxide edit
```

**Setup**: Add `eval "$(zoxide init bash)"` to your shell config for the `z` command.

### [lnav](https://github.com/tstack/lnav)
**Purpose**: Log file navigator and analyzer with automatic format detection

```bash
# View log files
lnav /var/log/syslog

# Multiple log files
lnav access.log error.log

# From stdin
tail -f /var/log/messages | lnav

# Search logs
lnav -c ';/error' logfile.log

# SQL queries on logs
lnav -c ';SELECT * FROM logline WHERE log_level = "error"' app.log
```

**Key shortcuts**: `/` (search), `n/N` (next/prev match), `t/T` (time navigation), `:` (command mode), `q` (quit)
