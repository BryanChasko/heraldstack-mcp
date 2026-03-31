#!/bin/bash
exec docker run --name mcp-vision-server-$(whoami)-$(date +%s) -i --rm vision-server:x86
