#!/bin/bash
exec docker run --name mcp-video-transcriber-$(whoami)-$(date +%s) -i --rm video-transcriber:x86
