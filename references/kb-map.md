# Knowledge-base map

The curated notes at `$KB_ROOT`. Consult these before searching the open web —
they are the sources already vetted, so citations stay consistent between
sessions.

If `$KB_ROOT` is unset or the path does not resolve, skip KB citation silently
and carry on. Never fabricate a note path.

| Area | Reach for it when |
|---|---|
| `$KB_ROOT/system-design` | Deciding a topology — storage, protocol, caching, sharding, consistency, replication |
| `$KB_ROOT/low-level-design` | Shaping classes — responsibilities, ownership, patterns, concurrency |
| `$KB_ROOT/engineering` | Changing a system that already exists and has users |
| `$KB_ROOT/dsa` | The algorithmic core of a problem |
| `$KB_ROOT/SOURCES.md` | The bibliography — when the notes aren't enough and you need the canonical source |

`engineering/` is the one most often relevant to work in an existing repo:

- `microservices/` — outbox, saga, database-per-service, API composition, strangler fig
- `evolution/` — parallel change (expand/contract), feature toggles, deployment patterns, refactoring
- `messaging/` — idempotent receiver, dead letter channel, competing consumers
- `stability/` — failure classification, timeouts & bulkheads, circuit breaker
- `testing/` — test pyramid, contract testing
- `security/` — OWASP essentials

## Citation rules

- Cite inline, at the decision: `per engineering/messaging/idempotent-receiver.md`.
- Cite only where it maps **cleanly**. A forced citation is worse than none.
- Mark anything you reason past the notes `[beyond KB]`. That marker is a
  signal a note is owed, not a failure — it's how the library finds its gaps.
- Prefer the most specific note. `engineering/stability/circuit-breaker.md`
  beats a general gesture at resilience.
