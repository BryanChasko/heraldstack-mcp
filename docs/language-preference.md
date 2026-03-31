---
title: heraldstack language preference
scope: new services, APIs, tools
---

## priority

rust > python > typescript

## when to use each

**rust** - new standalone services, cache proxies, high-throughput data processing, MCP server implementations (via mcp-rust-sdk), anything that needs to run hot + fast

**python** - agent logic, LangGraph orchestration, ML/embedding pipelines, qdrant-client integrations, hooks, automation scripts

**typescript** - only when extending existing node-based tooling (MCP launchers using npx, context7 integration, supergateway bridges). do not start new services in typescript

## rationale

rust gives us type safety + performance for infrastructure. python is the natural fit for agent orchestration + ML. typescript is already in the stack but not where we want to grow
