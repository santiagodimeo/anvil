## The `.map/` contract

`/map` caches its understanding of a repo in `.map/` at the repo root, so the
second visit costs nothing. These file names and sections are fixed — same in
every repo, every time.

```
.map/
  architecture.md       topology, entry points, external dependencies, request flow
  system-design.md      the design decisions actually made, and their tradeoffs
  low-level-design.md   the objects that matter and who owns what state
  data.md               entities and relations
  meta.json             build metadata, used for staleness detection
  work/                 per-task artifacts: spec.md, plan.md, findings.md
```

### `meta.json`

```json
{
  "built_at": "2026-08-05T14:22:00Z",
  "head_sha": "18b10cb...",
  "core_paths": ["src/server.ts", "prisma/schema.prisma", "package.json", "src/api/"],
  "anvil_version": "2"
}
```

`core_paths` are the files and directories the analysis actually leaned on:
entry points, config, schema and migration directories, dependency manifests,
top-level module directories. They are what staleness is measured against.

### What goes in each file

**`architecture.md`** — how the system is shaped. Services or modules and how
they talk. Where a request enters and what it touches on the way through.
External dependencies and what breaks when each one is down.

**`system-design.md`** — the decisions someone made and why. Storage choice,
caching, consistency model, sync vs async boundaries, auth approach. Where the
rationale isn't recoverable from the code, say so rather than inventing one.

**`low-level-design.md`** — the five to eight objects that carry the system.
What each owns, what state lives where, which invariants they hold. Not a class
inventory; the ones that matter.

**`data.md`** — entities, their relations, and cardinality, read from
migrations, schema files, or ORM models. Note what is denormalized on purpose
and what is soft-deleted, since neither is visible from a schema alone.

### Writing rules

Prose, in plain American English. Not tables of file paths.

Every file carries `path/to/file.ts:88` references so the detail is one jump
away — that is what these files are for, and why that detail does not belong in
chat.

A file with nothing behind it says so in one line and stops. `data.md` in a
service with no database reads "No database. State is in-memory per request,
rebuilt on boot." — not three paragraphs explaining the absence.

### Ignoring `.map/`

Never add `.map/` to the repo's own `.gitignore` — that puts a personal tool in
a shared file. Use git's global excludes instead, which is per-machine and never
committed:

1. Resolve the excludes file: `git config --global core.excludesFile`. When it
   is unset, git already uses `~/.config/git/ignore` (or
   `$XDG_CONFIG_HOME/git/ignore`) by default — use that path, don't set the
   config.
2. If `.map/` isn't in it, append it.
3. Say so in one line. Never mention it again.

Fallback when the global file can't be written: `.git/info/exclude` in the
current repo, which is also never committed.
