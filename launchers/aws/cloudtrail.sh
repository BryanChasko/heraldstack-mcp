#!/bin/bash
exec docker run --name mcp-cloudtrail-$(whoami)-$(date +%s) -i --rm \
  -v /home/bryanchasko/.aws:/root/.aws:ro \
  -e AWS_PROFILE=${AWS_PROFILE:-default} \
  -e AWS_REGION=${AWS_REGION:-us-east-1} \
  mcp/cloudtrail-mcp-server:latest
