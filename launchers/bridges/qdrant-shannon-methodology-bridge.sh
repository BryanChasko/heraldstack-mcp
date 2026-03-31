#!/usr/bin/env bash
# Stdio bridge to mcp-qdrant-multi shannon-methodology collection (port 8103)
exec npx supergateway --streamableHttp http://localhost:8103/shannon-methodology/mcp --outputTransport stdio
