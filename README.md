```
  +-[ heraldstack-mcp ]--------------------------------------+
  |  shannon . haunting . gander                            |
  |  unified mcp tooling -- single source of truth          |
  +---------------------------------------------------------+
```

unified mcp tooling library for the heraldstack. launcher scripts, dockerfiles,
and platform mcp configs across shannon (claude code), haunting (kiro-cli),
and gander (goose-cli) all live here.

## structure

- `launchers/` -- all mcp launcher scripts, organized by domain
- `dockerfiles/` -- baked docker images for mcp servers
- `configs/` -- canonical platform mcp configs (synced to each cli repo)
- `build/` -- image build scripts
- `docs/` -- registry schema and migration guide
- `registry.yaml` -- root launcher index (name, runtime, platform wiring, status)
