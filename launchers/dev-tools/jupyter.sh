#!/bin/bash
exec docker run --name mcp-jupyter-$(whoami)-$(date +%s) -i --rm mcp-jupyter-server:latest
