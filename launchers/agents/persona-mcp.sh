#!/bin/bash
exec docker run --name mcp-persona-mcp-$(whoami)-$(date +%s) -i --rm -p 3010:3010 -v persona-data:/data persona-mcp:x86
