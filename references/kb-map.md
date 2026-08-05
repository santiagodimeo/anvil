## Knowledge base

The curated notes at `$KB_ROOT`. Read them while reasoning, before searching the
open web — they're already vetted, so decisions stay consistent between sessions.

If `$KB_ROOT` is unset or doesn't resolve, skip this silently. Never invent a
note path.

| Area | Reach for it when |
|---|---|
| `$KB_ROOT/system-design` | Deciding a topology — storage, protocol, caching, sharding, consistency, replication |
| `$KB_ROOT/low-level-design` | Shaping classes — responsibilities, ownership, patterns, concurrency |
| `$KB_ROOT/engineering` | Changing a system that already exists and has users |
| `$KB_ROOT/dsa` | The algorithmic core of a problem |
| `$KB_ROOT/SOURCES.md` | The bibliography, when a note isn't enough and you need the canonical source |

`engineering/` is the one that usually applies to work in an existing repo:

- `microservices/` — outbox, saga, database-per-service, API composition, strangler fig
- `evolution/` — parallel change (expand/contract), feature toggles, deployment patterns
- `messaging/` — idempotent receiver, dead letter channel, competing consumers
- `stability/` — failure classification, timeouts and bulkheads, circuit breaker
- `testing/` — test pyramid, contract testing
- `security/` — OWASP essentials

### This is an input, not an output

The KB informs the decision. It doesn't get narrated back.

- **Cite it in the plan file**, at the decision it justifies:
  `per engineering/messaging/idempotent-receiver.md`. That's where it's useful
  later, and where the reader will actually look.
- **Never cite it in chat.** No "this embodies the X principle." No teaching
  asides. If the reader wants the reasoning, they'll ask or open the plan.
- Cite only where it maps cleanly. A forced citation is worse than none, and
  prefer the specific note — `stability/circuit-breaker.md` beats a general
  gesture at resilience.
- Mark reasoning that runs past the notes `[beyond KB]`. That marker means a
  note is owed, which is how the library finds its gaps.
