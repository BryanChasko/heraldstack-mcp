#!/bin/bash
exec docker run --name mcp-aws-iac-$(whoami)-$(date +%s) -i --rm \
  -v /home/bryanchasko/.aws:/root/.aws:ro \
  -e AWS_PROFILE=${AWS_PROFILE:-default} \
  -e AWS_REGION=${AWS_REGION:-us-east-1} \
  mcp/aws-iac-mcp-server:latest
