#!/bin/bash
set -a; source /home/bryanchasko/mcp-launchers/.env; set +a
export GITHUB_TOKEN=$(gh auth token 2>/dev/null || echo "$GITHUB_PERSONAL_ACCESS_TOKEN")
exec python3 /home/bryanchasko/code/heraldstack/heraldstack-mcp/launchers/utils/github-wrapper.py
