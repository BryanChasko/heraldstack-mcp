#!/bin/bash
exec docker run --name mcp-live-trace-jaeger-$(whoami)-$(date +%s) -i --rm \
  --network=host \
  -e JAEGER_URL=http://localhost \
  -e JAEGER_PORT=16686 \
  -e JAEGER_PROTOCOL=HTTP \
  jaeger-mcp:x86 \
  node /usr/local/lib/node_modules/jaeger-mcp-server/dist/index.js
