#!/bin/bash
exec docker run --name mcp-jaeger-ui-stagehand-$(whoami)-$(date +%s) -i --rm \
  --network=host \
  node:22-slim \
  npx -y stagehand-mcp
