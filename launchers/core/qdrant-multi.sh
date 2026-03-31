#!/bin/bash
exec docker run --name "mcp-qdrant-multi-$(whoami)-$(date +%s)" -i --rm \
  --network=host \
  -e QDRANT_URL=http://localhost:6333 \
  -e EMBEDDING_MODEL=sentence-transformers/all-MiniLM-L6-v2 \
  qdrant-mcp-baked:latest
