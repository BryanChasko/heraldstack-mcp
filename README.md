# heraldstack-mcp

Unified MCP tooling library for the HeraldStack. Single source of truth for all
launcher scripts, Dockerfiles, and platform MCP configs across shannon (Claude Code),
haunting (kiro-cli), and gander (goose-cli).

## Structure

- `launchers/` — All MCP launcher scripts, organized by domain
- `dockerfiles/` — Baked Docker images for MCP servers
- `configs/` — Canonical platform MCP configs (synced to each CLI repo)
- `build/` — Image build scripts
- `docs/` — Registry schema and migration guide
- `registry.yaml` — Master launcher index (name, runtime, platform wiring, status)
