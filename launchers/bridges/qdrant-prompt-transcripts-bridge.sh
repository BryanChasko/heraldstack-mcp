#!/usr/bin/env bash
# Stdio bridge to mcp-qdrant-multi prompt-transcripts collection (port 8103)
exec npx supergateway --streamableHttp http://localhost:8103/prompt-transcripts/mcp --outputTransport stdio
