#!/bin/bash
set -a; source /home/bryanchasko/mcp-launchers/.env; set +a
export PATH="/home/bryanchasko/.local/bin:$PATH"
exec uvx awslabs.valkey-mcp-server@latest
