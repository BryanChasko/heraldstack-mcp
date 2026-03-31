#!/bin/bash
exec docker run --name mcp-pdf-reader-$(whoami)-$(date +%s) -i --rm \
  -v /mnt/mac-mini/Documents:/documents \
  -e PDF_MOUNT_DIR=/documents \
  node:22-slim \
  npx -y @upstash/pdf-reader-mcp
