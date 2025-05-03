#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/logging.sh

if [[ $EUID -ne 0 ]]; then
  PRIVILEGE="sudo"
else
  PRIVILEGE=""
fi

log "Detecting package manager and installing Docker..."
if command -v pacman &>/dev/null; then
  log "Found pacman: installing Docker with pacman"
  ${PRIVILEGE} pacman -Sy --noconfirm docker docker-buildx docker-compose
elif command -v apt-get &>/dev/null; then
  log "Found apt: installing with Docker’s convenience script"
  curl -fsSL https://get.docker.com | ${PRIVILEGE} sh
elif command -v dnf &>/dev/null; then
  log "Found dnf: installing with Docker’s convenience script"
  curl -fsSL https://get.docker.com | ${PRIVILEGE} sh
elif command -v yum &>/dev/null; then
  log "Found yum: installing with Docker’s convenience script"
  curl -fsSL https://get.docker.com | ${PRIVILEGE} sh
elif command -v zypper &>/dev/null; then
  log "Found zypper: installing docker package"
  ${PRIVILEGE} zypper -n install docker
else
  log "No known package manager detected; falling back to convenience script"
  curl -fsSL https://get.docker.com | ${PRIVILEGE} sh
fi

docker --version && log "Docker installation complete 🎉"
