#!/bin/bash
exec docker run --name mcp-session-memory-$(whoami)-$(date +%s) -i --rm node:22-slim npx -y @modelcontextprotocol/server-memory
