#!/bin/bash
exec docker run --name mcp-ffmpeg-mcp-$(whoami)-$(date +%s) -i --rm ffmpeg-mcp:x86
