#!/usr/bin/env bash
# Cache cleanup functions

cleanup_caches() {
    log "clean up go cache"
    go clean -cache || true
    go clean -modcache || true
    
    log "clean up uv cache"
    uv cache clean || true
    
    log "clean up cargo cache"
    [ -d "$HOME"/.cargo/registry ] && rm -rf "$HOME"/.cargo/registry || true
}