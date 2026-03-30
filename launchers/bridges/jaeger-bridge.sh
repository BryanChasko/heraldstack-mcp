#!/usr/bin/env bash
# Stdio bridge to persistent mcp-jaeger HTTP endpoint (port 8120)
exec npx supergateway --streamableHttp http://localhost:8120/mcp --outputTransport stdio
