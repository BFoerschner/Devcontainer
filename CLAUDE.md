# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular containerized development environment that provides a comprehensive set of modern CLI development tools. The system uses a two-stage build approach: a base image (`devel_base`) containing core language toolchains, and specialized images for testing individual tools or tool categories.

## Build and Development Commands

### Core Build Commands
```bash
# Build base image with essential toolchains
./build_base.sh

# Build full development environment
docker build --build-arg INIT_SCRIPT_PATH=init.sh -t devimage .

# Build with tool categories for testing
docker build --build-arg INIT_SCRIPT_PATH=build-scripts/init_go_tools.sh -t devimage-go .
docker build --build-arg INIT_SCRIPT_PATH=build-scripts/init_rust_tools.sh -t devimage-rust .
docker build --build-arg INIT_SCRIPT_PATH=build-scripts/init_python_tools.sh -t devimage-python .
docker build --build-arg INIT_SCRIPT_PATH=build-scripts/init_nodejs_tools.sh -t devimage-nodejs .

# Build with individual tools for testing
docker build --build-arg INIT_SCRIPT_PATH=build-scripts/init_neovim.sh -t devimage-neovim .
docker build --build-arg INIT_SCRIPT_PATH=build-scripts/init_terraform.sh -t devimage-terraform .
docker build --build-arg INIT_SCRIPT_PATH=build-scripts/init_docker.sh -t devimage-docker .
```

### Running Containers
```bash
# Basic usage
docker run \
  -v "$HOME/.ssh/:/home/dev/.ssh:ro" \
  -v "/var/run/docker.sock:/var/run/docker.sock:ro" \
  -v $PWD/:/home/dev/host \
  -e LANG="C.UTF-8" \
  -e LC_ALL="C.UTF-8" \
  --rm -it \
  bfoerschner/devcontainer:latest

# Local development with X11
./run.sh
```

## Architecture

### Two-Stage Build System
1. **Base Stage** (`init_base.sh`): Installs core language toolchains (Go, Rust, Node.js, Python/UV, Lua) and environment setup (dotfiles, zsh, starship)
2. **Specialized Stage**: Builds on base image with specific tool categories or individual tools

### Directory Structure
- **`init_scripts/`**: Core installation scripts for individual tools and language toolchains
- **`build-scripts/`**: Modular build scripts for creating specialized container images
- **`bin/`**: Custom utility scripts
- **`init.sh`**: Main initialization script (installs all tools)
- **`init_base.sh`**: Base image initialization (core toolchains only)
- **`build_base.sh`**: Builds base image using `init_base.sh`

### Modular Build Scripts Architecture
The `build-scripts/` directory contains:

**Tool Installation Functions:**
- `common_setup.sh`: Environment setup and PATH configuration
- `go_tools.sh`: Go development tools (lazydocker, lazygit, mmv, nap, fzf, etc.)
- `cargo_tools.sh`: Rust tools (bat, eza, fd-find, ripgrep, du-dust, etc.)
- `uv_tools.sh`: Python tools via UV (harlequin, httpie, jrnl, visidata, ansible, etc.)
- `npm_tools.sh`: Node.js tools (@anthropic-ai/claude-code)
- `other_tools.sh`: Additional tools and binaries
- `cleanup_caches.sh`: Cache cleanup functions

**Container Build Scripts:**
- `init_*_tools.sh`: Tool category builds (go, rust, python, nodejs, devenv)
- `init_[tool].sh`: Individual tool builds (neovim, terraform, docker, kubectl, etc.)

### Key Design Principles
1. **DRY**: Modular functions prevent code duplication across build scripts
2. **Optimized Builds**: Base image contains expensive toolchain installations, specialized images only add specific tools
3. **Environment Consistency**: All scripts use `setup_environment()` for consistent PATH and environment variables
4. **Selective Testing**: Individual tool scripts enable focused testing and debugging

### Tool Categories
- **Go Tools**: Development TUIs (lazydocker, lazygit), CLI utilities (mmv, fzf, yq, direnv)
- **Rust Tools**: Modern CLI replacements (bat→cat, eza→ls, fd→find, ripgrep→grep, dust→du)
- **Python Tools**: Data analysis (visidata, harlequin), automation (ansible), development (llm, httpie)
- **Development Environment**: Editor (neovim), shell (zsh with dotfiles), multiplexer (tmux), infrastructure (docker, kubectl, terraform)

### Container Runtime
- **Entry Point**: tmux terminal multiplexer
- **Working Directory**: `/root/host` (mounted from host)
- **Shell**: zsh with custom dotfiles and starship prompt
- **Tool Access**: All tools available in PATH with modern alternatives symlinked (du→dust, df→duf)