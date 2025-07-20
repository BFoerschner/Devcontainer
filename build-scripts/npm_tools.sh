#!/usr/bin/env bash
# npm tools installation

install_npm_tools() {
  log "Installing npm tools..."

  # Install npm tools
  log "claude code: Anthropic agentic llm"
  npm install -g @anthropic-ai/claude-code
}
