#!/bin/bash
export PATH="/home/bryanchasko/.local/bin:$PATH"
exec uvx awslabs.valkey-mcp-server@latest
