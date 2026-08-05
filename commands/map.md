# Map — understand this repo
# Usage: /map [optional: a subsystem to go deeper on]
# Read-only. Caches its understanding in .map/ so the second visit is cheap.

You are building an understanding of this repository for someone who needs to
work in it — at architecture, system design, and data level.

Read-only throughout: Read, Glob, Grep, LS, LSP, and Bash for git and read-only
inspection. Never modify code. The only writes are inside `.map/`.

<!-- @include references/altitude.md -->

<!-- @include references/map-schema.md -->

---

## Step 0 — Which run is this?

Check for `.map/meta.json`.

- **Missing** → first run. Step 1.
- **Present** → returning run. Step 3.

---

## Step 1 — First run

**Ignore `.map/` first**, before writing anything, per the ignoring rules above.
One line of output.

Then analyze. Work outward from the entry points rather than reading everything:

1. **Shape** — `README`, dependency manifests, `docker-compose`, CI config, top
   level directories. What kind of system is this, what runs it, what does it
   depend on.
2. **Entry points** — the `main`, the server bootstrap, the route table, the
   CLI root, the queue consumers. Trace one representative request or job all
   the way through. That single trace tells you more than reading fifty files.
3. **Data** — migrations, schema files, or ORM models. Entities and their
   relations, and cardinality where the schema shows it.
4. **The objects that carry the system** — the five to eight types that hold
   state or coordinate. Usually visible from the trace in step 2.
5. **Decisions** — where the code shows a deliberate choice (a cache, a queue, a
   read replica, an idempotency key, a lock), record what it was and what it
   bought. Where the rationale isn't recoverable, say so rather than inventing
   one.

Write the four files and `meta.json`. Then Step 4.

Don't ask permission to start, and don't narrate progress through these steps.

---

## Step 2 — Going deeper (`/map <subsystem>`)

An argument means the reader wants one subsystem, not the whole repo. Trace that
subsystem specifically, answer in chat at the same altitude, and append what you
learned to the relevant `.map/` file. Skip the digest.

---

## Step 3 — Returning run

1. Read `meta.json`. Run
   `git diff --name-only <head_sha>..HEAD -- <core_paths>`.
2. Ask **one** question, using AskUserQuestion:

   > Full architecture, system design, low-level, and data — or just what's new?

   Options: "Just what's new" (default, listed first) / "Full picture".

3. If core paths changed, one line above the digest, naming the count:

   ```
   architecture.md is stale — 4 core files moved since it was built. Rebuild?
   ```

   Rebuild only if they say yes. A stale map is still mostly right.

4. "Full picture" prints the digest plus the prose summary. "Just what's new"
   prints the digest alone.

---

## Step 4 — The digest

This is the chat output. Same sections, every repo, every time.

```
Recent
[What moved in the last ~20 commits, grouped by theme, not by file. "Auth moved
to short-lived tokens; three PRs." Not a commit list — you're summarizing intent,
not replaying history. Note who's been working where if more than one person is.]

Product
[Epics, roadmap, and open tickets, from whatever tracker exists. What's in
flight, what's next, in three or four lines. Direction, not a backlog dump.]
```

On a first run, or on request, add a prose summary above those — roughly ten
lines total covering architecture, system design, low-level, and data. Enough to
orient someone, not a replacement for reading the files. Close with where the
files are:

```
Full detail in .map/ — architecture, system-design, low-level-design, data.
```

### Digest rules

- Plain American English prose. Not tables of paths, not bullet inventories.
- Each section fits on one screen. If it doesn't, you're listing instead of
  summarizing.
- A section with nothing behind it gets one line and stops. No tracker
  configured reads "No tracker wired up — nothing to report here." That's the
  whole section.
- No file paths in the digest unless a path *is* the answer. They're in `.map/`.

### Finding the product signal

In order, stopping at the first that resolves: tracker MCP tools available in
this session → tracker config in `.claude/project.json` → roadmap, epic, or
planning markdown in the repo → recent PR titles and descriptions → nothing.
