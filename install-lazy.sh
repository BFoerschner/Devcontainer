#!/usr/bin/env bash
set -Eeuo pipefail

# Usage:
#   ./install-lazy.sh [timeout_seconds]
#
# Example:
#   ./install-lazy.sh 30

TIMEOUT_SECONDS="${1:-30}"
LOG_FILE="${HOME}/.local/state/nvim/lazy.log"

if ! [[ "${TIMEOUT_SECONDS}" =~ ^[0-9]+$ ]] || [[ "${TIMEOUT_SECONDS}" -le 0 ]]; then
  echo "error: timeout must be a positive integer (seconds)" >&2
  exit 2
fi

export GIT_TERMINAL_PROMPT=0

echo "Running lazy.nvim sync with hard timeout (${TIMEOUT_SECONDS}s)..."

setsid nvim --headless "+lua require('lazy').sync({wait=true,show=false,concurrency=1})" +qa &
PGID_PID=$!

elapsed=0
while kill -0 "${PGID_PID}" 2>/dev/null; do
  if [[ "${elapsed}" -ge "${TIMEOUT_SECONDS}" ]]; then
    echo "Timed out after ${TIMEOUT_SECONDS}s. Killing process group -${PGID_PID}..."
    kill -KILL -"${PGID_PID}" 2>/dev/null || true
    wait "${PGID_PID}" 2>/dev/null || true

    if [[ -f "${LOG_FILE}" ]]; then
      echo
      echo "Last 120 lines of ${LOG_FILE}:"
      tail -n 120 "${LOG_FILE}" || true
    fi
    exit 124
  fi

  sleep 1
  elapsed=$((elapsed + 1))
done

if wait "${PGID_PID}"; then
  echo "Lazy sync completed successfully."
else
  status=$?
  echo "Lazy sync exited with status ${status}."
  exit "${status}"
fi
