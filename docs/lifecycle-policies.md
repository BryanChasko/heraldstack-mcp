---
title: heraldstack lifecycle policies
scope: all agents, all platforms, all data stores
---

## purpose

defines retention, rotation, cleanup, and security scanning cadences for all heraldstack data stores. prevents unbounded growth, stale data accumulation, and secret leakage across the agent ecosystem

## data store retention

| store | data type | retention | cleanup mechanism | notes |
|---|---|---|---|---|
| qdrant: copywriting | brand voice, copywriting assets | indefinite | manual curation | grows slowly, high-value content |
| qdrant: writing-inbox | raw captured content, drafts | 90 days | cron sweep (delete points older than 90d) | inbox is transient by design |
| qdrant: shared-knowledge | reference material, domain facts | indefinite | manual curation | cross-agent shared knowledge |
| qdrant: prompt-transcripts | raw + edited prompts | 180 days | cron sweep (archive then delete) | raw originals kept 180d, edited versions kept 1 year |
| qdrant: agent-memory | cherry-picked agent memory | 90 days | cron sweep (delete stale points) | shorter-term memory by design |
| qdrant: shannon-methodology | problem-solving patterns | indefinite | manual updates only | rarely changes |
| qdrant: verbal-ticks | agent identity registry | indefinite | manual updates only | rarely changes |
| valkey: qdrant cache | qdrant-find results | 15 min (TTL) | automatic expiry | cache-through pattern |
| valkey: steering cache | steering doc content | 30 min (TTL) | automatic expiry | invalidated on doc change |
| valkey: session state | session summaries | 1 hr (TTL) | automatic expiry + session end cleanup | cleared on session end |
| valkey: prompt pending | pending edit markers | 48 hr (TTL) | automatic expiry | deleted after editing |
| valkey: prompt edited | edit completion markers | 24 hr (TTL) | automatic expiry | consumed by cherry-pick |
| valkey: prompt cherrypicked | cherry-pick markers | 7 day (TTL) | automatic expiry | dedup window |
| valkey: inbox dedup | dedup fingerprints | 24 hr (TTL) | automatic expiry | prevents duplicate captures |
| local: prompt transcripts | `~/.agentic/prompt-transcripts/` | 180 days | cron: find + delete mtime > 180d | markdown files |
| local: replacement dumps | `~/.agentic/prompt-transcripts/replaced/` | 7 days | cron: find + delete mtime > 7d | daily curseword replacement logs |
| local: goose session memory | `gandergoosecli/memory/` | 30 days | cron: find + delete mtime > 30d | session-scoped, not cross-session |
| local: claude transcripts | `~/.claude/` | 30 days | claude code setting: cleanupPeriodDays=30 | managed by claude code |
| docker: jaeger traces | heraldstack-jaeger-data volume | 72 hours | jaeger `SPAN_STORAGE_TYPE=badger` + `--badger.maintenance-interval=300` | short-term observability |

## security scanning cadence

| scan type | target | cadence | mechanism | owner |
|---|---|---|---|---|
| secret scan — qdrant | all 7 collections | weekly | theseus-kade-vox-security-scanner agent | shannon (cron trigger) |
| secret scan — valkey | all cached values | weekly | theseus-kade-vox-security-scanner agent | shannon (cron trigger) |
| secret scan — transcripts | ~/.agentic/prompt-transcripts/ | daily | grep-based pattern scan (cron) | host cron |
| secret scan — public repos | heraldstack-mcp, HeraldStack | weekly | `git secrets --scan` or trufflehog | host cron |
| dependency audit | all repos with package.json/requirements.txt | monthly | `npm audit` / `pip-audit` | host cron |
| docker image scan | all custom Dockerfiles | monthly | `docker scout cve` or trivy | host cron |

### secret scan patterns

the security scanner checks for: AWS keys (AKIA*), GitHub PATs (ghp_*, github_pat_*), OpenRouter keys (sk-or-*), Anthropic keys (sk-ant-*), OpenAI keys (sk-*), SSH private keys, PGP keys, JWT tokens, connection strings with credentials, bearer tokens, passwords in URLs, high-entropy strings near sensitive keywords

### scan implementation

daily transcript scan (host crontab):
```
0 3 * * * grep -rlE '(AKIA[0-9A-Z]{16}|ghp_[a-zA-Z0-9]{36}|sk-or-|sk-ant-|sk-[a-zA-Z0-9]{48}|-----BEGIN.*PRIVATE KEY)' ~/.agentic/prompt-transcripts/ > /tmp/herald-secret-scan.log 2>&1 && [ -s /tmp/herald-secret-scan.log ] && echo "SECRET FOUND" | mail -s "heraldstack secret scan alert" bryanchasko || true
```

weekly qdrant + valkey scan (shannon cron or manual):
```
invoke theseus-kade-vox-security-scanner with target=all
```

## cleanup cron jobs

recommended host crontab entries:

```
# prompt transcript cleanup (180 days)
0 4 * * 0 find ~/.agentic/prompt-transcripts/ -name "*.md" -mtime +180 -delete

# replacement dump cleanup (7 days)
0 4 * * * find ~/.agentic/prompt-transcripts/replaced/ -name "*.md" -mtime +7 -delete

# goose session memory cleanup (30 days)
0 4 * * 0 find ~/code/heraldstack/gandergoosecli/memory/ -name "*.md" -mtime +30 -delete

# daily secret scan on transcripts
0 3 * * * grep -rlE '(AKIA[0-9A-Z]{16}|ghp_[a-zA-Z0-9]{36}|sk-or-|sk-ant-|sk-[a-zA-Z0-9]{48}|-----BEGIN.*PRIVATE KEY)' ~/.agentic/prompt-transcripts/ >> /tmp/herald-secret-scan.log 2>&1
```

## qdrant collection maintenance

qdrant does not auto-expire points. collections with retention limits need periodic cleanup:

writing-inbox (90 days):
- query all points, filter by metadata timestamp < (now - 90 days)
- delete matching points via qdrant REST API: `DELETE /collections/writing-inbox/points`
- run after deletion: `POST /collections/writing-inbox/index` to optimize

prompt-transcripts (180 days raw, 365 days edited):
- query points where metadata.edited=false and timestamp < (now - 180 days) -> delete
- query points where metadata.edited=true and timestamp < (now - 365 days) -> archive to shared-knowledge then delete

agent-memory (90 days):
- query points where metadata.cherry_picked_at < (now - 90 days) -> delete
- preserve any points with metadata.pinned=true (manually pinned by bryan)

## valkey memory management

valkey handles its own TTL expiry. additional safeguards:

- maxmemory policy: `allkeys-lru` (evict least-recently-used when memory limit hit)
- RDB snapshots: every 60 seconds if >= 1 key changed (configured in docker-compose)
- monitor memory: `valkey-cli info memory` — alert if used_memory exceeds 400MB of 512MB limit

## secret rotation cadence

| secret | rotation | method |
|---|---|---|
| OpenRouter API key | 90 days or on suspected exposure | edit ~/.secrets, chezmoi re-add, chezmoi push |
| GitHub PAT | 90 days or on suspected exposure | regenerate via github.com, update ~/.secrets |
| Anthropic API key | 90 days or on suspected exposure | regenerate via console.anthropic.com, update ~/.secrets |
| chezmoi age key | annual | `age-keygen`, re-encrypt, push to all machines |

## incident response

if the security scanner finds a leaked secret:

1. rotate the secret immediately (see rotation cadence above)
2. identify the leak source (which agent, which session, which collection)
3. purge the leaked value from all data stores (qdrant points, valkey keys, local files)
4. check if the secret reached any public repo (git log search)
5. if public exposure confirmed: revoke + regenerate + force-push to remove from git history
6. create a github issue on project 2 documenting the incident and remediation
