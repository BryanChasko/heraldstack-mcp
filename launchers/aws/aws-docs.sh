#!/bin/bash
exec docker run --name mcp-aws-docs-$(whoami)-$(date +%s) -i --rm mcp/aws-documentation-mcp-server:latest
