# CLI-Ready Development Environment

## Table of Contents

<!--toc:start-->
- [CLI-Ready Development Environment](#cli-ready-development-environment)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
    - [Goals:](#goals)
    - [Non-Goals:](#non-goals)
  - [Usage](#usage)
      - [First run](#first-run)
      - [Starting/attaching](#startingattaching)
<!--toc:end-->

## Overview

This repository contains the build-scripts for a ready-to-use image ```bfoerschner/devcontainer``` creating a Terminal-based 
development environment. The included tools are well-documented, fast and for the most part simple. The 
image is optimized for  modern features and speed.

The Image is based on the Dockerimage [Ubuntu:rolling](https://hub.docker.com/_/ubuntu). The [TOOLS](/docs/TOOLS.md) page has more information 
about the tools installed.

### Goals:
- **Easy to use**: The tools are well-documented and easy to learn
- **Configurable**: You can easily change the tools and their configuration
- **Shell Integration**: Terminal-first approach with rich command completions and aliases
- **Performance**: Fast tools that work well in containerized environments
- **Updates**: The tools are updated regularly and when feasible compiled from source

### Non-Goals:
- **Maintenance**: The tools are not maintained by the developer of this Dockerimage. Check the
[TOOLS](/docs/TOOLS.md) page for information about where to get support for the specific tool.
- **Compatibility**: The might or might not be compatible with other Linux distributions or other Dockerimages
- **Size**: The image is not optimized for size. It is optimized for speed and feature-completeness.


## Usage

#### First run
```bash
docker run \
  -v $HOME/.ssh/:/root/.ssh \ # Mount your SSH keys
  -v /var/run/docker.sock:/var/run/docker.sock \ # Mount Docker socket so we can control the hosts docker
  -v $PWD/:/root/host \ # Mount the host directory so we can edit files
  -e DISPLAY="host.docker.internal:0" \ # Share your display with the container
  -e LANG="C.UTF-8" \ # Set the locale to C.UTF-8
  -e LC_ALL="C.UTF-8" \ # Set the locale to C.UTF-8
  --name devcontainer \ # Name the container for later reuse (so we don't need to restart it every time
  -i \
  -t \
  bfoerschner/devcontainer:latest
```


| Flag/Option | Value                                     | Description                                     |
|-------------|-------------------------------------------|-------------------------------------------------|
| -v          | $HOME/.ssh/:/root/.ssh                    | Mount your own SSH keys                                  |
| -v          | /var/run/docker.sock:/var/run/docker.sock | Mount Docker socket for host Docker control     |
| -v          | $PWD/:/root/host                          | Mount current directory to /root/host           |
| -e          | DISPLAY="host.docker.internal:0"          | Share display with container                    |
| -e          | LANG="C.UTF-8"                            | Set locale to C.UTF-8                           |
| -e          | LC_ALL="C.UTF-8"                          | Set locale to C.UTF-8                           |
| --name      | devcontainer                              | Name container for reuse                        |
| -i          |                                           | Interactive mode - directly start into terminal |
| -t         |                                            | Allocate pseudo-TTY                            |
| | bfoerschner/devcontainer:latest | Image to use |


#### Starting/attaching
<container-name> is the name you gave it earlier (devcontainer if you're following the example above)

```bash
docker start -i <container-name>
```

if you detach from the running container by pressing ```ctrl-p + ctrl-q``` follow it by ```clear``` to 
remove the remaining outputbuffer. Detaching like that will keep the container running in the background.
```bash
# after detaching you can reattach to the container with:
docker attach -i <container-name> 
```
