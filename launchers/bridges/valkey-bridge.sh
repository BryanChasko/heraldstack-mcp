#!/usr/bin/env bash
# Stdio bridge to persistent mcp-valkey HTTP endpoint (port 8110)
exec npx supergateway --streamableHttp http://localhost:8110/mcp --outputTransport stdio
