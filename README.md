# CLI-Ready Development Environment

This repository contains a fully-configured development environment with modern CLI tools for a seamless 
terminal-based development experience.

## Overview

The development environment is based on the Dockerimage [Ubuntu:rolling](https://hub.docker.com/_/ubuntu). For a more 
detailed overview of the tools included in this Image see the [TOOLS](/docs/TOOLS.md) documentation.

### Features:
- **Consistent Theming**: Dark themes and modern interfaces
- **Modern DX**: Tools are selected to be easy to use and integrate with other tools
- **Shell Integration**: Optimized completions and aliases
- **Performance**: Fast tools that work well in containerized environments
- **Cross-Tool Workflows**: Output from one tool flows naturally to another

## Usage

### Start the container like this
```bash
docker run \
  -v $HOME/.ssh/:/root/.ssh \ # Mount your SSH keys
  -v /var/run/docker.sock:/var/run/docker.sock \ # Mount Docker socket so we can control the hosts docker
  -v $PWD/:/root/host \ # Mount the host directory so we can edit files
  -e DISPLAY="host.docker.internal:0" \ # Share your display with the container
  -e LANG="C.UTF-8" \ # Set the locale to C.UTF-8
  -e LC_ALL="C.UTF-8" \ # Set the locale to C.UTF-8
  --name devcontainer \ # Name the container for later reuse (so we don't need to restart it every time
  -it bfoerschner/devcontainer:latest
```

### If the container is stopped then you can start it interactively like this
```bash
docker start -i devcontainer # the name you gave it earlier
```

### If the container is still running then you can attach to it like this
```bash
docker attach -i devcontainer # the name you gave it earlier
```
