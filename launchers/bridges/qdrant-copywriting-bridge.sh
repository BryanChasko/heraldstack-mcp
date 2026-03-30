#!/usr/bin/env bash
# Stdio bridge to persistent mcp-qdrant-copywriting HTTP endpoint (port 8100)
exec npx supergateway --streamableHttp http://localhost:8100/mcp --outputTransport stdio
