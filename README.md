# Devcontainer

<p align="center">
  <img src="docs/images/devcontainer.jpg" alt="Devcontainer image">
  <sup><sup>source: ai</sup></sup>
</p>

## Overview

This repository contains the source for the image ```bfoerschner/devcontainer```. It is a terminal-based development environment that is fully configured and ready to use. The image is based on [Ubuntu:rolling](https://hub.docker.com/_/ubuntu) and includes the tools you need for a modern terminal-based development environment.

This image contains a set of curated set of applications and tools that are meant to improve your productivity and protect your sanity when working on projects. The dotfiles for this container are located at [bfoerschner/dotfiles](https://github.com/bfoerschner/dotfiles). They play a huge role in how this container feels.

I created the tool because I like to be able to have access to my personal development environment everywhere I can run docker. This is my take on how to solve the problem of having your own development environment with you at all times. As long as I have access to Linux containers via Docker I can be happy.

### Goals:
- **Ready to use**: The tools are pre-configured and ready to use
- **Documentation**: The tools are well-documented
- **Configurability**: The tools can be further configured to your needs
- **Terminal**: The tools are designed to work well in a terminal
- **Speed**: The tools are optimized for speed. Slow tools hinder the thinking process
- **Updates**: The tools are updated regularly and when feasible compiled from source

### Non-Goals:
- **Maintenance**: The tools are not maintained by the developer of this Dockerimage. Check the
[TOOLS](/docs/TOOLS.md) page for information about where to go for the specific tools for support.
- **Compatibility**: The tools might or might not be compatible with other Linux distributions or other Dockerimages
- **Size**: The image is not optimized for size. It is optimized for speed and feature-completeness.

## Usage

#### First run
```bash
docker run \
  -v $HOME/.ssh/:/root/.ssh \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD/:/root/host \
  -e DISPLAY="host.docker.internal:0" \
  -e LANG="C.UTF-8" \
  -e LC_ALL="C.UTF-8" \
  --name devcontainer \
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
docker attach <container-name> 
```
