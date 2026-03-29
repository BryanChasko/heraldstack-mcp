#!/bin/bash
# GITHUB_TOKEN sourced from ~/.secrets via shell env — no .env file needed
export GITHUB_TOKEN="${GITHUB_TOKEN:-$(gh auth token 2>/dev/null)}"
exec python3 /home/bryanchasko/code/heraldstack/heraldstack-mcp/launchers/utils/github-wrapper.py
