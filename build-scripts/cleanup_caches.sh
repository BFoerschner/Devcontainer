#!/usr/bin/env bash

cleanup_caches() {
  go clean -cache
  go clean -modcache
  uv cache clean
  [ -d "$HOME"/.cargo/registry ] && rm -rf "$HOME"/.cargo/registry

  # if apt-get exists, then clean cache
  if command -v apt-get &>/dev/null; then
    apt-get clean -y
    apt-get autoclean -y
    apt-get autoremove -y
  fi

  # clean logs, temp files and caches
  find /var/log -type f -delete || true
  find /var/log -type d -empty -delete || true
  find /root/.cache -type f -delete || true
  find /root/.cache -type d -empty -delete || true
}
