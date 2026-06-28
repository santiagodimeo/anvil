# Audit — codebase health check, no task in mind
# Usage: /audit [scope — optional, defaults to full project]
# Run periodically or when you sense something is wrong but
# can't name it. Read-only throughout.
# Reads CLAUDE.md + CLAUDE.local.md. Report is presented in the chat session.

You are doing a health audit of: $ARGUMENTS
(If no argument given, audit the full project.)

Use read-only tools only. Do not suggest or make any changes.
Your job is to see clearly and report honestly.

Scope: whole-codebase structural health, no diff in mind. For diff-scoped bug
review use `/code-review`; for security findings use `/security-review`. This
audit surfaces structural health and hands those off rather than duplicating them.

Use TodoWrite now to create a checklist of all steps so progress
is visible throughout the session.

---

## Step -1 — Branch awareness

<!-- @include references/branch-awareness.md -->

---

## Step 0 — Read existing context

Read CLAUDE.md then CLAUDE.local.md (if it exists).
Note any previously documented issues or warnings so you can
check if they've been addressed or have grown worse.

---

## Step 1 — Complexity concentration

Use Grep and Read to find:
- Files over 300 lines (flag, not a rule — just a signal)
- Functions with deeply nested logic (3+ levels)
- Files changed by 5+ different authors in the last 90 days
  (git log --format='%an' -- [file] | sort -u | wc -l)
- Files with the highest churn in last 90 days

Present as a ranked list with context, not just filenames.

---

## Step 2 — Code smells

Scan for:
- Duplicated logic — same pattern implemented more than once
- Inconsistent naming — same concept called different things
  in different parts of the codebase
- Dead code — use LSP find-references on exported symbols to
  confirm whether they are actually imported anywhere
- Commented-out code blocks
- TODO/FIXME/HACK density — where is tech debt concentrated?
- God objects — classes or modules doing too many unrelated things

Group findings by area, not file. Tell me where the smell
is concentrated, not just that it exists.

---

## Step 3 — Test coverage story

Without running tests:
- Which critical paths (auth, payments, data writes) have
  test files?
- Which don't?
- Are tests colocated with source or in a separate tree?
- What testing patterns are used? Are they consistent?
- Any test files that test nothing meaningful (mock everything,
  assert nothing important)?

---

## Step 4 — Dependency health

Read package.json (or equivalent). Without fetching live version data, flag:
- Dependencies that appear unused or duplicated
- Dev dependencies that have leaked into production imports
- Any obviously abandoned or known-problematic packages

For authoritative version currency and CVE checks, defer to `/security-review`
rather than guessing from a web search here.

---

## Step 5 — Consistency check

Pick 3 similar features or modules (e.g., 3 API routes,
3 service classes, 3 React components).
Compare them side by side:
- Do they follow the same structure?
- Do they handle errors the same way?
- Do they have similar test coverage?

Inconsistency here signals either evolution without refactor
or multiple authors without alignment. Both matter.

---

## Step 6 — Ask before concluding

Use AskUserQuestion to ask:

"I've completed the audit sweep. Before I write the report:"

Questions:
1. "Are there specific areas you suspected had problems?"
2. "Any known issues I should factor into the severity ranking?"
3. "Should I dig deeper into any area before concluding?"

Wait for the answer. Incorporate it.

---

## Step 7 — Present audit report in chat

Do NOT write to any file.

Output the audit report in the chat using this structure:

---
# Audit: $ARGUMENTS — [today's date]

## Summary
[3 sentences: overall health, biggest risk area, most urgent action.]

## High priority
[Issues that affect correctness, security, or will cause bugs.
Each with: what it is, where it is, why it matters.]

## Medium priority
[Issues that create maintenance burden or slow the team down.
Same format.]

## Low priority / hygiene
[Inconsistencies and smells that are worth fixing over time
but not urgent.]

## Bright spots
[What is working well and should be preserved or extended.
Audits that only surface problems miss half the picture.]

## Suggested first action
[The single highest-leverage thing to fix first, and why.]
---

## Step 8 — Confirm

End with:

"Audit complete. Run /focus [area] to go deep on any section before acting."
