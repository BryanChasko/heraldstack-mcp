#!/bin/bash
# Unified qdrant MCP launcher — parameterized by collection name.
# Usage: qdrant.sh <collection-name>
COLLECTION="${1:?Usage: qdrant.sh <collection-name>}"
exec docker run --name "mcp-qdrant-${COLLECTION}-$(whoami)-$(date +%s)" -i --rm \
  --network=host \
  -e QDRANT_URL=http://localhost:6333 \
  -e COLLECTION_NAME="$COLLECTION" \
  -e EMBEDDING_MODEL=sentence-transformers/all-MiniLM-L6-v2 \
  qdrant-mcp-baked:latest
