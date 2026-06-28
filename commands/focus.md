# Focus — understand the affected area before a task
# Usage: /focus [area, file, feature, or module name]
# Run before /blueprint when you need to understand a zone
# before planning. Read-only throughout.
# Reads CLAUDE.md + CLAUDE.local.md. Findings are presented in the chat session.

You are doing a targeted exploration of: $ARGUMENTS

Use read-only tools only (Read, Glob, Grep, LS, LSP, Bash for
git log and git blame only).
Do not write code or suggest changes.

Use TodoWrite now to create a checklist of all steps so progress
is visible throughout the session.

---

## Step -1 — Branch awareness

<!-- @include references/branch-awareness.md -->

---

## Step 0 — Read existing context

Read CLAUDE.md then CLAUDE.local.md (if it exists).
Note what is already known about $ARGUMENTS so you don't
repeat what's already documented.

Use AskUserQuestion to ask:
"What type of change are you planning in this zone?"

Options: "New feature" / "Bug fix" / "Refactor" / "Performance" / "Just exploring"

Use the answer to calibrate how deep to go in each step.

---

## Step 1 — Map the zone

Find all files related to $ARGUMENTS using Glob and Grep.
Use LSP find-references to trace entry points (where this is called
from) and exit points (what this calls or returns to).

Show me:
- The file list with a one-line description of each
- Entry points (where this is called from or initiated)
- Exit points (what this calls or returns to)
- Any config or environment variables this zone depends on

---

## Step 2 — Git history on this zone

Run: git log --oneline --since="60 days ago" -- [files in zone]
Run: git log --oneline --follow -10 [main file in zone]

Tell me:
- How recently and how often has this area changed?
- Who are the main contributors? (implicit ownership)
- Any recent large or suspicious commits?
- Files that always change together with this zone?

---

## Step 3 — Code patterns

Read the main files in this zone carefully.
Identify:
- Design patterns in use (what conventions must I follow here?)
- Naming conventions specific to this zone
- How errors are handled
- How this zone is tested — what testing approach is used?
- Any abstractions I must use vs ones I should not bypass

---

## Step 3.5 — Design lens

Read the zone through design vocabulary so the plan that follows has a
baseline to respect.

- **System-design altitude** — name the pattern this zone implements
  (request-response with a write-through cache, event-driven consumer,
  CQRS read model, etc.). Cite the KB where it maps
  (`per system-design/patterns/common-patterns.md`).
- **Low-level-design altitude** — name the OO structure: the
  orchestrator, who owns what state, where single responsibility holds
  and where it leaks. Cite the principle
  (`per low-level-design/design-principles.md`).

State the pattern plus the one design decision in this zone most likely
to constrain a change here. Mark anything beyond the KB `[beyond KB]`.

---

## Step 4 — Coupling and dependencies

Use LSP find-references to confirm what depends on $ARGUMENTS
and what $ARGUMENTS depends on.

Answer:
- What does $ARGUMENTS depend on? (imports, services, DB tables)
- What depends on $ARGUMENTS? (who calls this, who imports it)
- Is there anything tightly coupled that a change here would
  silently break?
- Any circular dependencies or unexpected relationships?

---

## Step 5 — Code smells in this zone

Flag only what's relevant to working in this area:
- TODOs, FIXMEs, HACKs with context on why they exist
- Functions or classes that are doing too much
- Inconsistencies with the patterns used elsewhere in the project
- Missing or weak test coverage on critical paths
- Anything that looks like it was meant to be temporary

Do not suggest fixes — just surface what I should know before
making changes here.

---

## Step 6 — Present findings in chat

Do NOT write to any file.

Output the findings in the chat using this structure:

---
# Focus: $ARGUMENTS — [today's date]

## Zone map
[Files and their roles]

## Design lens
[The SD pattern and LLD structure this zone uses, KB-cited where it maps]

## Patterns to follow
[What I must replicate to fit in here]

## Watch out for
[Coupling risks, smells, known fragility]

## Open questions about this zone
[Things I need to clarify before or during the task]
---

These findings live in this chat session and inform /blueprint when you run it.

## Step 7 — Confirm

End with:

"Ready to plan. Run /blueprint $ARGUMENTS when you're ready
to move from understanding to planning."
