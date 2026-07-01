---
name: {{PROJECT_SLUG}}-review
description: Light self-review of the current branch diff for {{PROJECT_NAME}} — correctness, the project's architectural invariants, scope, and "does it meet the acceptance bar". Deliberately not strict; flags real issues, ignores nits.
allowed-tools: Bash(git *), Read, Grep, Glob
---

# {{PROJECT_SLUG}}-review

A **light** code review of the work on the current branch — the kind a trusted teammate
does in five minutes, not a forensic audit. Goal: catch real problems before merge without
blocking on style. Pair with `{{PROJECT_SLUG}}-verify` (which proves it runs).

## Steps

1. Get the diff: `git diff {{BASE_BRANCH}}...HEAD --stat`, then read the changed files (the
   diff, not the whole repo).
2. Check, in priority order — flag only what's genuinely wrong:
   - **Acceptance bar:** does the change actually do what the roadmap phase requires?
   - **Architectural invariants** (from `CLAUDE.md`): the boundaries and contracts that
     project declares must not be violated.
   - **Correctness:** obvious bugs, unhandled rejections, swallowed errors, off-by-one,
     leaked timers/listeners/handles.
   - **Secrets:** no tokens/keys/credentials committed.
   - **Scope:** no edits to vendored/`reference/` material; no work pulled forward from
     later phases; no stray debug/log statements left in shipped paths.
3. Fix anything trivial yourself (typo, dead import, a missed error guard). Leave anything
   larger as a flagged finding.

## Output

A short verdict:

- `APPROVE — <one line>` if it meets the bar and respects the invariants.
- `APPROVE WITH FIXES — <what you fixed>` if you corrected trivia inline.
- `CHANGES NEEDED — <the 1–3 real issues>` if something genuine is wrong (caller fixes,
  then re-review).

## Not this skill's job

Style/formatting, naming bikesheds, test-coverage maximalism, performance micro-tuning,
or anything not touching correctness/invariants/scope. Keep it light — strictness here
just stalls the autopilot. Save the deep, forensic pass for when the human is back.
