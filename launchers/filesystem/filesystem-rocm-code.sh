#!/bin/bash
exec docker run --name mcp-filesystem-rocm-code-$(whoami)-$(date +%s) -i --rm \
  -v /home/bryanchasko/code:/projects/code \
  -v /home/bryanchasko/.kiro:/projects/.kiro \
  -v /home/bryanchasko/.claude:/projects/.claude \
  -v /home/bryanchasko/.config:/projects/.config \
  mcp/filesystem:latest /projects/code /projects/.kiro /projects/.claude /projects/.config
