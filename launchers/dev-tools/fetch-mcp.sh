#!/bin/bash
exec docker run --name "mcp-fetch-$(whoami)-$(date +%s)" -i --rm \
  --network=host \
  node:22-slim \
  npx -y @modelcontextprotocol/server-fetch
