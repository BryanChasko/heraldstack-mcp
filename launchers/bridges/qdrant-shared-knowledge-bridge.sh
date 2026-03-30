#!/usr/bin/env bash
# Stdio bridge to persistent mcp-qdrant-shared-knowledge HTTP endpoint (port 8102)
exec npx supergateway --streamableHttp http://localhost:8102/mcp --outputTransport stdio
