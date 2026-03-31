#!/bin/bash
# MCP launcher dispatcher - cross-platform (Linux/macOS)
# Routes MCP server scripts to ROCm-AIBOX for execution.
# On AIBOX: executes locally. On other machines: SSHes to AIBOX.
#
# Usage: run.sh <script-name>.sh
# Resolves script name across category subdirectories automatically.

LAUNCHERS_ROOT="/home/bryanchasko/code/heraldstack/heraldstack-mcp/launchers"
SCRIPT_NAME="$1"

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

if [ "$(hostname)" = "rocm-aibox" ]; then
  exec "$SCRIPT_PATH"
else
  exec ssh bryanchasko@rocm-aibox.local "$SCRIPT_PATH"
fi
