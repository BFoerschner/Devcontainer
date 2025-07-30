# Development Tools Documentation

This document provides comprehensive documentation for all tools installed inside the devcontainer. Tools are compiled from source when feasible. The tools are well-documented and for the most part easy to learn.

## Quick Reference


| Tool                                        | Purpose                               | Documentation                                     |
| ------------------------------------------- | ------------------------------------- | ------------------------------------------------- |
| [eza](#eza) | Modern `ls` with icons and git status | [Docs](https://eza.rocks/)                        |
| [fd-find](#fd-find)    | Fast alternative to `find`            | [Docs](https://github.com/sharkdp/fd#how-to-use)       |
| [fzf](#fzf)      | Fuzzy finder for files and commands   | [Docs](https://github.com/junegunn/fzf#usage)     |
| [bat](#bat)       | Syntax-highlighted file viewer        | [Docs](https://github.com/sharkdp/bat#how-to-use)      |
| [mmv](#mmv)   | Rename multiple files with editor     | [Docs](https://github.com/itchyny/mmv#usage) |
| [termscp](#termscp) | Terminal file transfer client         | [Docs](https://termscp.veeso.dev/)                |
| [ripgrep](#ripgrep) | Ultra-fast text search            | [Docs](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md)   |
| [choose](#choose) | Human-friendly `cut` alternative  | [Docs](https://github.com/theryangeary/choose) |
| [pandoc](#pandoc)          | Universal document converter      | [Docs](https://pandoc.org/)                           |
| [silicon](#silicon)     | Create beautiful code screenshots | [Docs](https://github.com/Aloxaf/silicon#examples)       |
| [procs](#procs)   | Modern `ps` replacement        | [Docs](https://github.com/dalance/procs#usage) |
| [du-dust](#du-dust) | Better disk usage analyzer     | [Docs](https://github.com/bootandy/dust#usage) |
| [duf](#duf)        | Modern `df` with better output | [Docs](https://github.com/muesli/duf#usage)   |
| [lazygit](#lazygit) | Terminal UI for Git    | [Docs](https://github.com/jesseduffield/lazygit#usage) |
| [git-delta](#git-delta)    | Better git diff viewer | [Docs](https://dandavison.github.io/delta/)            |
| [gh](#gh)                    | GitHub CLI             | [Docs](https://cli.github.com/manual/)                 |
| [difftastic](#difftastic) | Structural diff tool   | [Docs](https://difftastic.wilfred.me.uk/)              |
| [lazydocker](#lazydocker) | Terminal UI for Docker      | [Docs](https://github.com/jesseduffield/lazydocker#usage) |
| [dive](#dive)                 | Analyze Docker image layers | [Docs](https://github.com/wagoodman/dive)          |
| [docker](#docker)                    | Container runtime           | [Docs](https://docs.docker.com/reference/cli/docker/)                          |
| [kubectl](#kubectl)          | Kubernetes CLI              | [Docs](https://kubernetes.io/docs/reference/kubectl/)     |
| [k9s](#k9s)                   | Kubernetes CLI dashboard    | [Docs](https://k9scli.io/)                                |
| [terraform](#terraform)       | Infrastructure as Code      | [Docs](https://developer.hashicorp.com/terraform/docs)    |
| [neovim](#neovim)       | Advanced text editor                | [Docs](https://neovim.io/doc/)                            |
| [tmux](#tmux)             | Terminal multiplexer                | [Docs](https://man7.org/linux/man-pages/man1/tmux.1.html) |
| [starship](#starship) | Cross-shell prompt                  | [Docs](https://starship.rs/guide/)                        |
| [direnv](#direnv)       | Per-directory environment variables | [Docs](https://github.com/direnv/direnv#docs)                          |
| [carapace](#carapace)  | Multi-shell completions             | [Docs](https://carapace-sh.github.io/carapace-bin/setup.html)               |
| [harlequin](#harlequin)  | Terminal SQL IDE          | [Docs](https://harlequin.sh/docs/getting-started/index)         |
| [visidata](#visidata)      | Terminal spreadsheet      | [Docs](https://visidata.org/docs/)         |
| [httpie](#httpie)          | User-friendly HTTP client | [Docs](https://httpie.io/docs/cli)         |
| [mitmproxy](#mitmproxy) | Interactive HTTPS proxy   | [Docs](https://docs.mitmproxy.org/stable/) |
| [claude-code](#claude-code)                                   | AI-powered code assistant | [Docs]("https://docs.anthropic.com/en/docs/claude-code/overview") |
| [llm](#llm)       | Large Language Model CLI  | [Docs](https://llm.datasette.io/en/stable/)     |
| [ansible](#ansible) | IT automation platform    | [Docs](https://docs.ansible.com/)                   |
| [just](#just) | Command runner      | [Docs](https://just.systems/man/en/)     |
| [yq](#yq) | YAML/JSON processor | [Docs](https://mikefarah.gitbook.io/yq/) |
| [jrnl](#jrnl) | Command-line journaling | [Docs](https://jrnl.sh/en/latest/)              |
| [nap](#nap) | Code snippet manager    | [Docs](https://github.com/maaslalani/nap) |
| [nu](#nu) | Modern shell with structured data | [Docs](https://www.nushell.sh/book/)          |
| [tea](#tea)   | Gitea CLI client                  | [Docs](https://docs.gitea.com/usage/cli/tea/) |
| [timewarrior](#timewarrior) | Time tracking tool      | [Docs](https://timewarrior.net/docs/)         |


---

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

### [fd-find](https://github.com/sharkdp/fd)
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

### [mmv](https://github.com/itchyny/mmv)
**Purpose**: Rename multiple files with your editor  


```bash
# Rename files matching pattern
mmv '*.txt'

# Use specific editor
mmv -e vim '*.md'

# Dry run
mmv -n '*.py'
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

### [git-delta](https://github.com/dandavison/delta)
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

### [docker](https://github.com/docker/cli)
**Purpose**: Container runtime  


```bash
# Run container
docker run -it ubuntu:latest

# Build image
docker build -t myapp .

# List containers
docker ps -a
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

### [direnv](https://github.com/direnv/direnv)
**Purpose**: Environment variable management per directory  

```bash
# Allow .envrc
direnv allow

# Create environment
echo 'export API_KEY="secret"' > .envrc
```

### [carapace](https://github.com/carapace-sh/carapace-bin)
**Purpose**: Multi-shell completion generator  


```bash
# Generate completions
carapace docker
carapace git

# List supported commands
carapace --list
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

### [llm](https://github.com/simonw/llm)
**Purpose**: Large Language Model CLI  


```bash
# Ask question
llm "Explain Docker containers"

# Process content
cat README.md | llm "Summarize this document"

# Install models
llm install llm-gpt4all
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

### [nap](https://github.com/maaslalani/nap)
**Purpose**: Code snippet manager  


```bash
# Launch interface
nap

# Add snippet from file
nap add myfile.go

# Search snippets
nap search "function"
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

### [tea](https://gitea.com/gitea/tea)
**Purpose**: Gitea CLI client  

```bash
# Login
tea login add

# List repositories
tea repos list

# Create issue
tea issues create --title "Bug" --body "Description"
```

### [timewarrior](https://github.com/GothenburgBitFactory/timewarrior)
**Purpose**: Command-line time tracking tool  

```bash
# Start tracking
timew start "Project work"

# Stop current tracking
timew stop

# Track with tags
timew start project:website coding

# Show summary
timew summary

# Show today's time
timew day

# Track for specific duration
timew track 9am - 5pm "Full day work"
```
