#!/bin/bash
exec docker run --name mcp-prompt-crafter-mcp-$(whoami)-$(date +%s) -i --rm -p 3013:3013 prompt-crafter-mcp:x86
