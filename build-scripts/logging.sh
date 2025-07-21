#!/usr/bin/env bash
readonly INFO_COLOR="\033[1;32m"
readonly ERROR_COLOR="\033[1;31m"
readonly RESET_COLOR="\033[0m"

log() {
  printf "%b[INFO]%b %s\n" "$INFO_COLOR" "$RESET_COLOR" "$1"
}

error() {
  printf "%b[ERROR]%b %s\n" "$ERROR_COLOR" "$RESET_COLOR" "$1" >&2
}

# Handle Ctrl-C (SIGINT)
trap 'log "Aborted by user"; exit 0' SIGINT
