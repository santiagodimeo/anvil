# {{PROJECT_NAME}} autopilot

An unsupervised build loop that drives `docs/product/roadmap.md` to done — plan, build,
test, review, PR, merge — one phase at a time. Leave it running for hours; come back to
merged PRs and a `runlog.md`.

## The pieces

```
.claude/
  commands/
    autopilot.md     /autopilot [max-phases]  — the loop (this is what you run)
    ship-phase.md    /ship-phase [N]          — one phase, end to end (a loop unit)
  skills/
    {{PROJECT_SLUG}}-verify/   essential testing gate ({{VERIFY_CMD}})
    {{PROJECT_SLUG}}-review/   light self-review gate (correctness · invariants · scope)
  autopilot/
    README.md        this file
    progress.md      the ledger — source of truth for what's done / next
    runlog.md        appended each run (created at runtime)
```

It reuses the **anvil** central commands in spirit (`/blueprint`, `/contribute`,
`/create-pr`, `/audit`) but runs **non-interactively** — anvil's versions gate on human
approval, which would stall an unsupervised run. The local commands strip those gates and
keep the same protocols (gitflow branches, conventional commits, What/Why/Result PRs).

## One-time setup

```
git rev-parse --is-inside-work-tree   # must be a repo
git switch -c {{BASE_BRANCH}}          # integration base, off main
```
Needs `gh auth status` OK + an `origin` remote for PRs. No remote → no-PR mode
(branches/commits/merges locally, logs that PRs were skipped).

## Run

```
/autopilot          # run until a phase fails its gate, or the roadmap is complete
/autopilot 2        # do at most 2 phases, then stop
/ship-phase 1       # just phase 1, by hand
```

## How it behaves (so you can trust it overnight)

- **Sequential & compounding:** phase N branches off the merged `{{BASE_BRANCH}}`, so each
  builds on the last. One phase = one branch = one PR.
- **Gated:** a phase merges only if `{{PROJECT_SLUG}}-verify` is green **and**
  `{{PROJECT_SLUG}}-review` approves. Review is intentionally light — real issues, not nits.
- **Stop-on-red:** after 2 failed fix attempts it stops, leaves the branch/PR open, and
  writes the diagnosis. A human is cheaper than a thrash loop.
- **Scoped:** only app code + `docs/` + config change. Vendored/reference material is never
  touched. No `--force`, no gold-plating, no pulling future phases forward.
- **No questions:** it never prompts. If it can't default a decision safely, it stops and
  logs `BLOCKED` rather than guess.

## Stop / resume

Interrupt any time — state lives in `progress.md`, not memory. Re-run `/autopilot` to
resume at the next `todo`. To redo a phase, set it back to `todo` in the ledger.

## Toggle: auto-merge vs review-first

Default is **auto-merge on green** (max autonomy). To make it stop after each PR for your
review instead, change the merge step of `ship-phase.md` from "squash-merge" to "leave PR
open and STOP". Trade autonomy for a human gate per phase.
