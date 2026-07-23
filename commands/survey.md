# Survey — map a zone against the repo's own standards before changing it
# Usage: /survey [ticket key, area, file, feature, or module name]
# The project-aware counterpart to /focus. Reads the repo's declared
# conventions and the knowledge base; asks only what they can't answer.
# Read-only throughout. Findings are presented in the chat session.

You are doing a targeted exploration of: $ARGUMENTS

Use read-only tools only (Read, Glob, Grep, LS, LSP, Bash for git log and
git blame only, and the tracker's MCP tools if one is configured).
Do not write code or suggest changes.

Use TodoWrite now to create a checklist of all steps so progress is visible
throughout the session.

---

## Step 0 — Resolve the repo's standards

<!-- @include references/project-standards.md -->

Print the `Derived from this repo` block now, before anything else. Everything
below inherits it.

---

## Step 0.5 — Resolve the target

If a tracker is configured and `$ARGUMENTS` matches its key pattern
(`<team_key>-<number>`, e.g. `EUP-304`):

- Fetch the ticket. Take its **description**, **labels**, **estimate**, and
  **branch name**.
- A well-written ticket often names the exact files and line numbers in scope.
  Use those as the exploration seed rather than rediscovering them — then
  verify each one still exists and still says what the ticket claims. Tickets
  go stale; report any drift you find as a finding.
- If the ticket has a parent, read it too for the surrounding intent.

Otherwise treat `$ARGUMENTS` as a free-text zone and find it yourself.

Either way, state in one line what you are surveying and where that came from.

---

## Step 1 — Map the zone

Find all files related to the target using Glob and Grep. Use LSP
find-references to trace entry points (where this is called from) and exit
points (what this calls or returns to).

Show me:
- The file list with a one-line description of each
- Entry points (where this is called from or initiated)
- Exit points (what this calls or returns to)
- Any config or environment variables this zone depends on

---

## Step 2 — Git history on this zone

Run: `git log --oneline --since="60 days ago" -- [files in zone]`
Run: `git log --oneline --follow -10 [main file in zone]`

Tell me:
- How recently and how often has this area changed?
- Who are the main contributors? (implicit ownership)
- Any recent large or suspicious commits?
- Files that always change together with this zone?

---

## Step 3 — Code patterns

Read the main files in this zone carefully. Identify:
- Design patterns in use (what conventions must I follow here?)
- Naming conventions specific to this zone
- How errors are handled
- How this zone is tested — what approach, at what altitude?
- Any abstractions I must use vs ones I should not bypass

---

## Step 3.5 — Design lens

<!-- @include references/kb-map.md -->

Read the zone at three altitudes so the plan that follows has a baseline to
respect. Name the pattern at each, cite where it maps cleanly:

- **System design** — the architectural shape this zone implements
  (request-response with a write-through cache, event-driven consumer, CQRS
  read model). Cite `per system-design/...`.
- **Low-level design** — the OO structure: the orchestrator, who owns what
  state, where single responsibility holds and where it leaks. Cite
  `per low-level-design/...`.
- **Engineering** — the operational pattern, and **whether its obligations are
  actually met**. This is the altitude that finds real bugs: a
  competing-consumers worker with no idempotent receiver, an outbox with no
  terminal state, a remote call with no timeout, a schema change with no
  expand/contract path. Cite `per engineering/...`.

State the pattern at each altitude, then **the one design decision in this zone
most likely to constrain a change here**. Mark anything beyond the notes
`[beyond KB]`.

---

## Step 4 — Coupling and dependencies

Use LSP find-references to confirm what depends on the target and what the
target depends on.

Answer:
- What does it depend on? (imports, services, DB tables)
- What depends on it? (who calls this, who imports it)
- Is there anything tightly coupled that a change here would silently break?
- Any circular dependencies or unexpected relationships?

---

## Step 5 — Code smells in this zone

Flag only what's relevant to working in this area:
- TODOs, FIXMEs, HACKs with context on why they exist
- Functions or classes doing too much
- Inconsistencies with the patterns used elsewhere in the project
- Missing or weak test coverage on critical paths
- Anything that looks like it was meant to be temporary

Do not suggest fixes — surface what I should know before making changes here.

---

## Step 6 — Repo standards that constrain a change here

From `CLAUDE.md`, `.claude/project.json` and the skills list already read in
Step 0, name the conventions a change in **this specific zone** must satisfy.
Not the whole rulebook — only what binds here. Typically:

- Which test tiers cover this zone, and which the repo requires before merge
- Whether a doc, baseline, or count has to move in lockstep with the code
- PR sizing limits, and roughly how many PRs this zone's work implies
- Security rules that apply to this surface (auth, tenancy, validation, secrets)
- Any flag, migration, or retrofit convention this zone follows

If the repo declares none of this, say so plainly and move on.

---

## Step 7 — Present findings in chat

Do NOT write to any file.

Output the findings in the chat using this structure:

---
# Survey: $ARGUMENTS — [today's date]

## Derived from this repo
[The block from Step 0, unchanged]

## Target
[What's being surveyed and where the definition came from — ticket or free text]

## Zone map
[Files and their roles]

## Design lens
[SD pattern · LLD structure · engineering pattern and whether its obligations
are met. KB-cited where it maps.]

## Patterns to follow
[What I must replicate to fit in here]

## Repo standards in play
[Only what binds a change in this zone]

## Watch out for
[Coupling risks, smells, known fragility, ticket-vs-code drift]

## Open questions about this zone
[Things I need to clarify before or during the task]
---

## Step 8 — Confirm

End with:

"Ready to plan. Run `/draft $ARGUMENTS` to move from understanding to
planning — it inherits this survey."
