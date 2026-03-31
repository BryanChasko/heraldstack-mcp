#!/bin/bash
exec docker run --name mcp-stagehand-$(whoami)-$(date +%s) -i --rm \
  --network=host \
  node:22-slim \
  npx -y @browserbasehq/stagehand-mcp
