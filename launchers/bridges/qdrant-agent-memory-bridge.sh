#!/usr/bin/env bash
# Stdio bridge to mcp-qdrant-multi agent-memory collection (port 8103)
exec npx supergateway --streamableHttp http://localhost:8103/agent-memory/mcp --outputTransport stdio
