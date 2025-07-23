#!/usr/bin/env bash

cleanup_caches() {
  go clean -cache
  go clean -modcache
  uv cache clean
  [ -d "$HOME"/.cargo/registry ] && rm -rf "$HOME"/.cargo/registry
  apt-get autoremove -y &&
    apt-get clean &&
    apt-get autoclean
}
