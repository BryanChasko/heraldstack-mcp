#!/bin/bash
exec docker run --name mcp-sqlite-$(whoami)-$(date +%s) -i --rm \
  -v /home/bryanchasko/code/learning/deep-agents-from-scratch/data/mcp_shared:/data \
  sqlite-mcp:latest \
  --db-path /data/agents.db
