#!/bin/bash
exec docker run --name mcp-notebook-mcp-$(whoami)-$(date +%s) -i --rm -v notebook-data:/data notebook-mcp:x86
