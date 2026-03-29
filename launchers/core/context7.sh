#!/bin/bash
set -a; source /home/bryanchasko/mcp-launchers/.env; set +a
export PATH="/home/bryanchasko/.nvm/versions/node/v24.14.0/bin:$PATH"
exec env CLIENT_IP_ENCRYPTION_KEY="$CLIENT_IP_ENCRYPTION_KEY" npx --prefer-offline -y @upstash/context7-mcp
