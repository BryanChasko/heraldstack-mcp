#!/usr/bin/env bash
set -euo pipefail

OPENROUTER_MCP_ROOT="${OPENROUTER_MCP_ROOT:-/home/bryanchasko/code/heraldstack/mcp-openrouter}"
exec node "${OPENROUTER_MCP_ROOT}/src/index.js"
