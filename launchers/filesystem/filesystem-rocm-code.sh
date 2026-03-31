#!/bin/bash
exec docker run --name mcp-filesystem-rocm-code-$(whoami)-$(date +%s) -i --rm \
  -v /home/bryanchasko/code:/projects/code \
  -v /home/bryanchasko/.kiro:/projects/.kiro \
  mcp/filesystem:latest /projects/code /projects/.kiro
