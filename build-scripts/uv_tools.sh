#!/usr/bin/env bash
# UV/Python tools installation

install_uv_tools() {
    log "Installing UV tools..."
    
    log "harlequin: SQL IDE with database support"
    uv tool install 'harlequin[postgres,mysql,s3]' --force

    log "httpie: HTTP client"
    uv tool install 'httpie' --force

    log "jrnl: Command-line journal"
    uv tool install 'jrnl' --force

    log "llm: Large Language Model CLI"
    uv tool install 'llm' --force

    log "go-task-bin: Task runner"
    uv tool install 'go-task-bin' --force

    log "visidata: Data exploration tool"
    uv tool install 'visidata' --force

    log "mitmproxy: HTTP proxy for testing"
    uv tool install 'mitmproxy' --force

    log "ansible: IT automation platform"
    uv tool install 'ansible' --force

    log "ansible-core: Ansible core components"
    uv tool install 'ansible-core' --force
}