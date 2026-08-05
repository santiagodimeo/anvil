# Ship — branch, commit, PR, CI, review
# Usage: /ship
# Everything between your last approval and your merge. Automated. You merge.

Run the whole sequence without checking in between steps. The gates are behind
you (spec, plan) and ahead of you (merge) — this part is mechanical.

<!-- @include references/altitude.md -->

<!-- @include references/repo-signals.md -->

**Defer to the repo's own pipeline.** If `.claude/skills/` has its own create-pr,
audit, or merge skills, run those instead of the steps below and follow their
rules. anvil fills gaps; it doesn't override a repo that's already solved this.

---

## Step 1 — Branch

<!-- @include references/branch-awareness.md -->

---

## Step 2 — Commit

Use the `commit` skill. Group by logical unit — a working tree that mixes two
concerns becomes two commits, not one.

---

## Step 3 — Open the PR

Push, then use the `create-pr` skill.

The **Files changed** section lists what a reviewer has to actually read. Skip
lockfiles, generated output, and mechanical renames — collapse those into "plus
N mechanical renames" rather than listing them.

The **Test plan** comes from what the plan's steps actually verified, not from
what you wish were tested. If nothing is covered by a test, say that plainly and
give the manual steps.

---

## Step 4 — CI and the review gauntlet

Kick off CI, then run these in parallel while it goes:

| Check | How |
|---|---|
| Code review | the native `/code-review` |
| Security | the native `/security-review` |
| Dependency vulns | whatever the repo uses — `npm audit`, `pip-audit`, `cargo audit`, `govulncheck` |
| Lint and types | the verify command from the derived block |

Don't reimplement any of these. Wait for CI to finish.

---

## Step 5 — Report

**Blockers only, in chat.** A blocker is: a failing check, a security finding, a
vulnerable dependency with a fix available, or a correctness bug in this diff.

Each gets three lines — what, why it matters, the fix as a decision:

```
SQL injection in the new search filter — high.
User input goes into the query string unparameterized.
I'd parameterize it. Want me to?
```

Everything else — style, non-blocking suggestions, findings from elsewhere in
the repo — goes to `.map/work/<slug>/findings.md`. It gets exactly one line in
chat, at the end:

```
7 non-blocking notes in .map/work/oauth-login/findings.md.
```

Clean run, no blockers:

```
PR #42 — CI green, review clean, no vulns.
https://github.com/org/repo/pull/42
```

Then stop. The merge is theirs, via the `merge-pr` skill when they want it.

---

## Fixing blockers

If they say fix it, fix it, push, and report in one line per blocker resolved.
Don't re-run the whole gauntlet unless the fix was large enough to warrant it —
re-run the check that failed.
