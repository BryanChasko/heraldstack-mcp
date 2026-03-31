#!/usr/bin/env bash
# Stdio bridge to mcp-qdrant-multi verbal-ticks collection (port 8103)
exec npx supergateway --streamableHttp http://localhost:8103/verbal-ticks/mcp --outputTransport stdio
