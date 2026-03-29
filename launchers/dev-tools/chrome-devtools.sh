#!/bin/bash
exec docker run --name mcp-chrome-devtools-$(whoami)-$(date +%s) -i --rm \
  --network=host \
  node:22-slim \
  npx -y @anthropic/chrome-devtools-mcp
