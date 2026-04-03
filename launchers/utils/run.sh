#!/bin/bash
# MCP launcher dispatcher - cross-platform (Linux/macOS)
# Routes MCP server scripts to ROCm-AIBOX for execution.
# On AIBOX: executes locally. On other machines: SSHes to AIBOX.
#
# Usage: run.sh <script-name>.sh
# Resolves script name across category subdirectories automatically.

set -euo pipefail

LAUNCHERS_ROOT="${HERALDSTACK_MCP_LAUNCHERS_ROOT:-/home/bryanchasko/code/heraldstack/heraldstack-mcp/launchers}"
SCRIPT_NAME="${1:-}"
AIBOX_HOSTNAME="${HERALDSTACK_AIBOX_HOSTNAME:-rocm-aibox}"
AIBOX_HOST="${HERALDSTACK_AIBOX_HOST:-rocm-aibox.local}"
AIBOX_USER="${HERALDSTACK_AIBOX_USER:-hs-mujallad}"
SSH_CONNECT_TIMEOUT="${HERALDSTACK_AIBOX_SSH_CONNECT_TIMEOUT:-5}"

if [ -z "$SCRIPT_NAME" ]; then
  echo "Usage: run.sh <script-name>.sh" >&2
  exit 1
fi

# Resolve script across category subdirectories
SCRIPT_PATH=$(find "$LAUNCHERS_ROOT" -name "$SCRIPT_NAME" -type f ! -path "*/utils/run.sh" 2>/dev/null | head -1)

if [ -z "$SCRIPT_PATH" ]; then
  echo "Error: launcher '$SCRIPT_NAME' not found in $LAUNCHERS_ROOT" >&2
  exit 1
fi

CURRENT_HOST="$(hostname 2>/dev/null || true)"
CURRENT_HOST_SHORT="$(hostname -s 2>/dev/null || true)"
if [ "$CURRENT_HOST" = "$AIBOX_HOSTNAME" ] || [ "$CURRENT_HOST_SHORT" = "$AIBOX_HOSTNAME" ]; then
  exec "$SCRIPT_PATH"
else
  exec ssh \
    -o BatchMode=yes \
    -o ConnectTimeout="$SSH_CONNECT_TIMEOUT" \
    -o ConnectionAttempts=1 \
    -o StrictHostKeyChecking=accept-new \
    "${AIBOX_USER}@${AIBOX_HOST}" "$SCRIPT_PATH"
fi
