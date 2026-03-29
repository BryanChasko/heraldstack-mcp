#!/bin/bash
exec docker run --name mcp-docker-mcp-$(whoami)-$(date +%s) -i --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  mcp/docker --transport stdio
