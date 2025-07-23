#!/usr/bin/env bash

cleanup_caches() {
  go clean -cache
  go clean -modcache
  uv cache clean
  [ -d "$HOME"/.cargo/registry ] && rm -rf "$HOME"/.cargo/registry
  apt-get clean &&
    apt-get autoclean &&
    apt-get autoremove -y
}

