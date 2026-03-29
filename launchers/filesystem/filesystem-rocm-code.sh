#!/bin/bash
exec docker run --name mcp-filesystem-rocm-code-$(whoami)-$(date +%s) -i --rm -v /home/bryanchasko/code:/projects/code mcp/filesystem:latest
