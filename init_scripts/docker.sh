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
  # Add Docker's official GPG key:
  ${PRIVILEGE} apt-get update
  ${PRIVILEGE} apt-get install ca-certificates curl
  ${PRIVILEGE} install -m 0755 -d /etc/apt/keyrings
  ${PRIVILEGE} curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  ${PRIVILEGE} chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
    ${PRIVILEGE} tee /etc/apt/sources.list.d/docker.list >/dev/null
  ${PRIVILEGE} apt-get update

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
