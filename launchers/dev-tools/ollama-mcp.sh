#!/bin/bash
exec docker run -i --rm \
  --network=host \
  -e OLLAMA_HOST=http://localhost:11434 \
  --name ollama-mcp-$(date +%s) \
  node:22-slim \
  npx -y ollama-mcp-server
