# Draft — plan the implementation against the repo's own standards
# Usage: /draft [ticket key, task, or feature name]
# The project-aware counterpart to /blueprint. Derives what the repo already
# states, asks only the judgment questions, shapes the plan to the repo's
# sizing limits, and hands off to the repo's own ship path.
# Run after /survey when the zone needs understanding first.

You are starting a structured planning session for: $ARGUMENTS

Call EnterPlanMode now. You may only use read-only tools (Read, Glob, Grep, LS,
WebSearch, and the tracker's MCP tools if configured) until the user approves
the plan and you call ExitPlanMode.

---

## Step 0 — Resolve the repo's standards

<!-- @include references/project-standards.md -->

If `/survey` already ran in this session, reuse its derived block rather than
re-deriving — say so in one line and move on.

Print the `Derived from this repo` block now.

---

## Step 0.5 — Classify

The canonical taxonomy — the single source, do not redefine it:

<!-- @include references/work-types.md -->

**Derive the work type rather than asking**, in this order:

1. The tracker ticket's label, mapped onto the taxonomy above (a `backend`
   label on a ticket adding a column is `feat`; a `docs` label is `docs`).
2. The ticket title's own conventional-commit prefix, if it has one.
3. The branch name's gitflow prefix, if you're already on a feature branch.

Print the type as part of the derived block with its source, e.g.
`work type   feat   (ticket label: backend)`. If none of the three resolve,
**then** ask — that's the only case where this becomes a question.

---

## Step 0.6 — Design gate

For feat, fix, perf, refactor, or security that touches architecture or class
structure, decide once whether the design is settled before planning:

- **Needs architecture work** (new topology, service boundary, data model,
  consistency or scaling decision) → suggest `/sd-design` first, then return.
- **Needs class / object design** (new component, non-trivial ownership or
  responsibilities) → suggest `/lld-design` first.
- **Design is obvious or already done** (`/survey` or a design command already
  ran) → plan directly.

A suggestion, not an automatic handoff. If the design is clear, say so and
proceed — don't manufacture a detour.

---

## Step 1 — Ask the judgment questions

These are the questions a repo cannot answer for you. Use AskUserQuestion, ask
ONLY the ones relevant to the derived type, maximum 3, all at once.

Never ask anything already printed in the derived block. If a ticket
description already answers one of these, skip it and cite the ticket instead.

### feat
1. What does success look like — the user-visible or system-level outcome?
2. Constraints to design around (no new deps, backward compatible, perf budget)?
3. Is there a simpler version that delivers 80% of the value?

### fix / refactor / perf
1. What's the broken or degraded behaviour — expected vs actual?
2. Do you know where this originates, or should I trace it?
3. Constraints on the fix — public API frozen, stay in one file?

### hotfix
1. The exact failure — error, affected users, severity?
2. Surface area — isolated, or shared infrastructure?
3. Feature flag or direct patch?

### security
1. Vulnerability class — injection, auth bypass, data exposure, CVE, other?
2. Blast radius — what data or users are at risk?
3. Temporary mitigation in place, or blocking?

### chore / infra
1. Desired end state — what looks different after this?
2. Risk of breaking existing behaviour or CI?

### docs / test
1. What's missing or wrong — coverage gap, outdated content, target area?

### research
1. What question are you trying to answer?
2. What would "good enough to decide" look like?
3. Is there a time box?

### spike
1. The hypothesis — what are you proving or disproving?
2. The time box?
3. The go/no-go signal at the end?

### rfc
1. What decision needs making, and who owns it?
2. The 2–3 options in play?
3. The criteria for evaluating them?

### postmortem
1. The incident — service, duration, impact?
2. Do you have a timeline, or should I reconstruct it?
3. Is the immediate fix deployed?

Wait for answers before building the plan.

---

## Step 2 — Investigate if needed

If any answer is "I don't know", use read-only tools to find it before
proceeding — Grep and Read to trace code paths, Glob to map structure,
WebSearch for patterns or CVEs.

Tell the user what you found before folding it into the plan. Give them the
chance to correct your interpretation.

---

## Step 3 — Build the plan using the right shape

<!-- @include references/kb-map.md -->

Choose the shape by type. Do not mix shapes.

**Two constraints apply to every shape:**

- **Cite the KB at each significant decision** — `per engineering/...`,
  `per system-design/...`, `per low-level-design/...`. Mark anything past the
  notes `[beyond KB]`.
- **Shape the work to the repo's declared sizing limits** (from the derived
  block). If the repo caps a PR at one concept area, split at concept
  boundaries and say up front how many PRs this implies. Sizing problems belong
  at plan time, not at PR time.

### Shape A — Code changes (feat, fix, hotfix, perf, refactor, security)

---
## [type](scope): $ARGUMENTS

### Overview
[2 sentences max. What this is and why it matters. A non-engineer should
understand it.]

### Current state        ← include for fix, hotfix, perf, refactor, security
                         ← skip for feat
[Step-by-step of the broken, slow, or risky path as it exists today.]

### Approach
[Chosen direction in one paragraph, KB-cited where it maps.]
[Rejected alternative + one-line reason it lost.]

### Implementation steps

Each step must be:
- Independently committable
- Verifiable before the next step starts
- Minimal — no changes beyond what the step requires

Step N
  What changes: [files and what changes in each — no code]
  Test anchor:  [what proves this step worked]
  Verify:       [the repo's verify command, from the derived block]
  Commit:       type(scope): imperative message

### PR shape
[How these steps group into PRs under the repo's sizing limits. One line per PR.
Omit this section entirely if the repo declares no limits.]

### Rollback
[One line per commit. "Revert [commit], run [command if needed]."]

### Done when
[Concrete and testable. The repo's verify command passes, behaviour X confirmed.]
---

### Shape B — Research / Spike

---
## research: $ARGUMENTS   OR   spike: $ARGUMENTS

### Question
[The specific thing we are trying to learn or validate.]

### Hypothesis          ← spike only
[What we believe is true and are testing.]

### Investigation steps
[Ordered, each with a clear output: "produces a decision", "produces a
benchmark".]

### Time box            ← spike only
[Hard stop. What we have at the end regardless of completeness.]

### Go / no-go signal   ← spike only
[The measurable condition that determines next action.]

### Output format
[What this produces: doc, PR, decision, nothing-and-we-stop.]
---

### Shape C — RFC

---
## rfc: $ARGUMENTS

### Decision required
[One sentence. What we are deciding and who owns it.]

### Context
[Why this decision needs making now.]

### Options

Option A — [name]
  How it works: ...
  Fits when: ...
  Cost / risk: ...

Option B — [name]
  How it works: ...
  Fits when: ...
  Cost / risk: ...

### Evaluation criteria
[The criteria agreed in Step 1. Ranked if possible.]

### Recommendation
[Only if there is a clear answer.]

### Next step
[Who reviews this, by when, in what format.]
---

### Shape D — Postmortem

---
## postmortem: $ARGUMENTS

### Incident summary
[Service, duration, user impact — 2 sentences.]

### Timeline
[Ordered events. Discovery → escalation → mitigation → resolution.]

### Root cause
[The actual cause, not the symptom.]

### Contributing factors
[What made this possible or worse — process, tooling, coverage gaps.]

### Immediate fix
[Deployed or pending — what it does.]

### Prevention steps
[Ordered, ownable. Each with what it prevents and who owns it.]

### Done when
[The conditions under which this incident is closed.]
---

### Shape E — Chore / Docs / Test / Infra

Shape A without "Current state", simplified to Overview → Steps with commits →
Done when.

---

## Step 4 — Critique before presenting

Before showing the plan, internally check:

- Is any step too large to commit independently?
- Does any step assume something not confirmed in the codebase?
- Is there a simpler path to the same outcome?
- Does any step violate single responsibility or cross the zone's existing
  architectural / ownership boundaries?
- **Does every step end at a state where the repo's verify command passes?**
- **Does the PR grouping respect the repo's declared sizing limits?**
- Does any decision that maps to the KB go uncited — or any citation get forced
  where it doesn't fit?
- For changes with real design weight: should this have gone through
  `/sd-design` or `/lld-design` first?
- For hotfix/security: is the rollback actually executable?

Revise if needed. Then present.

End every plan with exactly this line:

"Review the plan above. Reply 'go' to start step 1, or tell me what to change."

When the user replies 'go': call ExitPlanMode, then begin step 1.

---

## Step 5 — Hand off to the repo's ship path

After all steps are complete and "Done when" is confirmed, stop and report what
changed.

Draft plans and implements — it does not commit, push, or open PRs. Publishing
is a separate, deliberate step.

Name the ship path **derived in Step 0**, not a fixed command. For a repo whose
skills declare a pipeline, that's its own chain, in its own order:

```
Work complete. This repo declares a ship pipeline:
  /create-pr → /audit-pr → /merge-pr        (from .claude/skills/)
Run /create-pr when you're ready.
```

For a repo with no declared pipeline, hand off to `/contribute`.
