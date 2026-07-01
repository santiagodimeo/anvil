# Ship Phase — one roadmap phase, end to end
# Usage: /ship-phase [phase-number]
# Plan → build → verify → review → commit → PR → merge, for a single phase.

Take **one** `docs/product/roadmap.md` phase from nothing to merged. Phase = `$ARGUMENTS`
(default: the lowest `todo` phase in `.claude/autopilot/progress.md`).

This mirrors anvil's `/blueprint` + `/contribute` + `/create-pr`, but runs
**non-interactively** — no approval gates. Make defaults; record them.

## 1 · Branch

- From clean `{{BASE_BRANCH}}`, create `feat/p<N>-<slug>` (slug from the phase title).
- This replaces anvil's interactive branch-guard. Never work on `main`/`{{BASE_BRANCH}}` directly.

## 2 · Plan (inline, no plan-mode)

Read: the target phase in `docs/product/roadmap.md`, the relevant source code, and — if the
phase ports proven behavior — the matching file in any `reference/` material (study only).
Write a short plan to `.claude/autopilot/runlog.md`: the acceptance bar, the files you'll
touch, and the 3–6 steps. Keep it tight; then build.

## 3 · Build to the acceptance bar

Implement exactly what the phase's **Acceptance** line demands — no more. Follow
`CLAUDE.md` invariants. Prefer porting proven behavior from `reference/` (rewritten behind
your own seam) over inventing. Add/extend unit tests for any core logic you write —
essential coverage, not exhaustive.

## 4 · Verify gate (must be green)

Invoke the **{{PROJECT_SLUG}}-verify** skill. If red, fix and re-run — **max 2 attempts**.
Still red → mark the phase `blocked`, STOP, leave the branch for review.

## 5 · Review gate (light)

Invoke the **{{PROJECT_SLUG}}-review** skill on the branch diff. Fix anything it flags as a
real issue; ignore nits. Not strict — correctness, the `CLAUDE.md` invariants, scope, and
"does it meet the acceptance bar" only.

## 6 · Commit

Logical, conventional commits (`type(scope): subject`, imperative). Group by concern; don't
dump one mega-commit. Stage deliberately — never `git add -A` over stray files.

## 7 · PR (if remote exists)

Push `-u origin <branch>`. Open a PR with `gh pr create --base {{BASE_BRANCH}}`, title
`type(scope): phase N — <title>`, body:

```
## What
<the change, 1–3 lines>

## Why
Roadmap phase N — <acceptance bar, verbatim>.

## Result
- verify: <gate summary>
- review: <one-line verdict>
- <key behaviors now working>

🤖 autopilot
```

No remote → skip PR, note it in the ledger.

## 8 · Merge & record

If verify is green and review passed: `gh pr merge <#> --squash --delete-branch` (or, in
no-PR mode, `git checkout {{BASE_BRANCH}} && git merge --squash <branch>` + commit). Update
`.claude/autopilot/progress.md`: set the phase `done`, record branch + PR URL + date.
Return to `{{BASE_BRANCH}}`. Done — the next phase builds on this.
