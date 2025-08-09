#!/usr/bin/env bash

cleanup_caches() {
  go clean -cache
  go clean -modcache
  uv cache clean
  [ -d "$HOME"/.cargo/registry ] && rm -rf "$HOME"/.cargo/registry

  # Determine if we need sudo
  local use_sudo=""
  if [ "$EUID" -ne 0 ]; then
    use_sudo="sudo"
  fi

  # if apt-get exists, then clean cache
  if command -v apt-get &>/dev/null; then
    $use_sudo apt-get clean -y
    $use_sudo apt-get autoclean -y
    $use_sudo apt-get autoremove -y
  fi

  # clean logs, temp files and caches
  $use_sudo find /var/log -type f -delete || true
  $use_sudo find /var/log -type d -empty -delete || true
  find /root/.cache -type f -delete 2>/dev/null || $use_sudo find /root/.cache -type f -delete || true
  find /root/.cache -type d -empty -delete 2>/dev/null || $use_sudo find /root/.cache -type d -empty -delete || true
}
