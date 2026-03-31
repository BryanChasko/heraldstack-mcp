#!/bin/bash
exec docker run --name mcp-gooseai-mcp-$(whoami)-$(date +%s) -i --rm \
  -e GOOSEAI_API_KEY="${GOOSEAI_API_KEY}" \
  -e OPENROUTER_API_KEY="${OPENROUTER_API_KEY}" \
  gooseai-mcp-server
