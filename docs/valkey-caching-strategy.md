---
title: valkey caching strategy
scope: all agents, all platforms
---

## purpose

valkey serves as a short-TTL cache layer for frequently accessed qdrant data and agent state. qdrant remains the authoritative store; valkey accelerates hot-path reads

## what gets cached

| key pattern | data | TTL | source |
|---|---|---|---|
| qdrant:{collection}:{query_hash} | qdrant-find results | 15min (900s) | any qdrant query |
| session:{cli}:{session_id}:summary | session state summary | 1hr (3600s) | session end hook |
| steering:{doc_slug} | steering doc content | 30min (1800s) | doc reads |
| prompt:pending:{transcript_id} | pending edit timestamp | 48hr (172800s) | prompt-transcribe |
| prompt:edited:{transcript_id} | edit completion marker | 24hr (86400s) | prompt-editor-cron |
| prompt:cherrypicked:{transcript_id} | cherry-pick marker | 7d (604800s) | prompt-cherrypick |
| inbox:dedup:{fingerprint} | dedup timestamp | 24hr (86400s) | inbox-capture |

## invalidation rules

- qdrant write (qdrant-store) invalidates all keys matching `qdrant:{collection}:*` for the affected collection
- steering doc changes (watcher.py hook) invalidate `steering:*`
- session end clears `session:{cli}:{session_id}:*`
- explicit cache-bust via valkey delete when data is known stale

## query hash

query_hash = first 16 chars of sha256(lowercase(query_text)). collision risk is acceptable for a 15-minute cache

## cache-through pattern

```
result = valkey.get(cache_key)
if result is None:
    result = qdrant.find(collection, query)
    valkey.set(cache_key, serialize(result), ttl)
return result
```

agents should use the cache helpers in heraldstackdeepagentscli/src/heraldstack/hooks/cache.py for the python implementation. MCP-based agents use valkey string_get/string_set directly
