#!/bin/bash
# docker mcp server — linux-compatible via ckreiling/mcp-server-docker (PyPI)
# uses python docker sdk against /var/run/docker.sock
# replaces mcp/docker which is docker desktop (macos/windows) only
exec uvx mcp-server-docker
