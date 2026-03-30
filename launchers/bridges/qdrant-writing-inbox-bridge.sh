#!/usr/bin/env bash
# Stdio bridge to persistent mcp-qdrant-writing-inbox HTTP endpoint (port 8101)
exec npx supergateway --streamableHttp http://localhost:8101/mcp --outputTransport stdio
