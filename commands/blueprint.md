# Plan — dynamic planning command
# Usage: /plan [task or feature name]
# Works in any project. Run after your explore/debate phase.

You are starting a structured planning session for: $ARGUMENTS

Call EnterPlanMode now. You may only use read-only tools (Read, Glob,
Grep, LS, WebSearch) until the user approves the plan and you call
ExitPlanMode.

## Voice & approach
Short, technical, plain. No preamble, no hedging, no trailing summary.
Decisions, not options-dumps — every significant choice names one
alternative and the one-line reason it lost.
Teach as you go: when a step embodies a design principle, name it (cite
the KB if it maps) so this stays daily work you also learn from.

## Knowledge base
When a plan choice maps to the knowledge base, cite it inline:
- `SD=$KB_ROOT/system-design`
  (e.g. `per system-design/patterns/common-patterns.md`)
- `LLD=$KB_ROOT/low-level-design`
  (e.g. `per low-level-design/design-principles.md`)
Cite only where it maps cleanly; mark anything beyond the notes `[beyond KB]`.

---

## Step -1 — Branch awareness

Run: `git branch --show-current 2>/dev/null` and note the branch name.
If not in a git repo, skip this step entirely.

Use AskUserQuestion to ask (customise the message based on the actual branch name):

- **main or master** → "⚠️ You're on `main`. Gitflow convention is to work on feature/, fix/, or hotfix/ branches. Do you want to continue here, or create / switch to a branch first?"
- **develop** → "You're on `develop`. Are you working directly here, or do you want to spin off a feature branch?"
- **Any other branch** → "You're on `[branch]`. Any existing in-progress work here I should know about? Is this the right branch for this work?"

Options: "Continue here" / "Create or switch to another branch"

If the user wants to create or switch branches, help them before proceeding.

---

## Step 0 — Classify (always ask this first)

Use AskUserQuestion to ask:

"What type of task is this?

  Code changes:
    feat     — new capability or behaviour
    fix      — bug that affects existing behaviour
    hotfix   — critical fix, needs immediate deploy
    perf     — performance improvement, no behaviour change
    refactor — internal restructure, no behaviour change
    security — vulnerability or hardening concern

  Non-code:
    chore    — tooling, deps, config, CI
    docs     — documentation only
    test     — adding or fixing tests only
    infra    — infrastructure or deployment

  Strategic:
    research — open investigation, no defined output yet
    spike    — time-boxed proof of concept with a hypothesis
    rfc      — proposal requiring team decision
    postmortem — incident review and prevention

Type a number or keyword — or just describe it and I'll classify."

Wait for the answer before proceeding.

---

## Step 0.5 — Design gate

For feat, fix, perf, refactor, or security that touches architecture or
class structure, decide once whether the design is settled before planning:

- **Needs architecture work** (new topology, service boundary, data
  model, consistency or scaling decision) → suggest the user run
  `/sd-design` first, then return to `/blueprint`.
- **Needs class / object design** (new component, non-trivial ownership
  or responsibilities) → suggest `/lld-design` first.
- **Design is obvious or already done** (e.g. `/focus` or a design
  command already ran) → plan directly.

This is a suggestion to the user, not an automatic handoff. If the
design is clear, say so and proceed — don't manufacture a detour.

---

## Step 1 — Ask targeted questions by type

Based on the type, use AskUserQuestion to ask ONLY the questions
relevant to that category. Maximum 3 questions. Ask them all at once.

### feat
1. What does success look like — what's the user-visible or system-level
   outcome when this is done?
2. Are there constraints I should design around (no new deps, must be
   backward compatible, specific perf budget)?
3. Is there a simpler version of this that delivers 80% of the value?

### fix / refactor / perf
1. Can you describe the broken or degraded behaviour — what should
   happen vs what actually happens?
2. Do you know where in the code this originates, or should I trace it?
3. Any constraints on the fix — must not change public API, must stay
   in one file, etc.?

### hotfix
1. What is the exact failure — error message, affected users, severity?
2. What is the surface area — is this isolated or does it touch shared
   infrastructure?
3. Do we need a feature flag or a direct patch?

### security
1. What is the vulnerability class — injection, auth bypass, data
   exposure, dependency CVE, other?
2. What is the blast radius — what data or users are at risk?
3. Is there a temporary mitigation in place, or is this blocking?

### chore / infra
1. What is the desired end state — what looks different after this?
2. Is there a risk of breaking existing behaviour or CI?

### docs / test
1. What is missing or wrong — gap in coverage, outdated content,
   specific area to target?

### research
1. What is the question you're trying to answer?
2. What would "good enough to decide" look like as an output?
3. Is there a time box on this?

### spike
1. What is the hypothesis — what are you trying to prove or disprove?
2. What is the time box?
3. What is the go/no-go signal at the end?

### rfc
1. What decision needs to be made, and who owns it?
2. What are the 2–3 options in play?
3. What are the criteria the team will use to evaluate them?

### postmortem
1. What was the incident — service, duration, impact?
2. Do you have a timeline of events, or should I reconstruct from
   git log and logs you provide?
3. Is the immediate fix already deployed?

Wait for answers before building the plan.

---

## Step 2 — Investigate if needed

If any answer is "I don't know" or "not sure", use read-only tools to
find the answer before proceeding:
- Grep and Read to trace code paths
- Glob to map file structure
- WebSearch to research patterns or CVEs

Tell the user what you found before incorporating it into the plan.
Give them the chance to correct your interpretation.

---

## Step 3 — Build the plan using the right shape

Choose the plan shape based on type. Do not mix shapes.

### Shape A — Code changes (feat, fix, hotfix, perf, refactor, security)

---
## [type](scope): $ARGUMENTS

### Overview
[2 sentences max. What this is and why it matters.
Foolproof — a non-engineer should understand this.]

### Current state        ← include for fix, hotfix, perf, refactor, security
                         ← skip for feat
[Step-by-step of the broken, slow, or risky path as it exists today.]

### Approach
[Chosen direction in one paragraph.]
[Rejected alternative + one-line reason why.]

### Implementation steps

Each step must be:
- Independently committable
- Verifiable before the next step starts
- Minimal — no changes beyond what the step requires

Step N
  What changes: [files and what changes in each — no code]
  Test anchor:  [what proves this step worked]
  Commit:       type(scope): imperative message

### Rollback
[One line per commit. "Revert [commit], run [command if needed]."]

### Done when
[Concrete, testable. Lint clean, tests pass, behaviour X is confirmed.]
---

### Shape B — Research / Spike

---
## research: $ARGUMENTS   OR   spike: $ARGUMENTS

### Question
[The specific thing we are trying to learn or validate.]

### Hypothesis          ← spike only
[What we believe is true and are testing.]

### Investigation steps
[Ordered list of what to look at, search, or build — each with
a clear output: "produces a decision", "produces a benchmark", etc.]

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
[One sentence. What we are deciding and who owns the decision.]

### Context
[Why this decision needs to be made now.]

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
[The criteria agreed in step 1. Ranked if possible.]

### Recommendation
[Optional — only include if there is a clear answer.]

### Next step
[Who reviews this, by when, in what format.]
---

### Shape D — Postmortem

---
## postmortem: $ARGUMENTS

### Incident summary
[Service, duration, user impact — 2 sentences.]

### Timeline
[Ordered events with approximate times.
Discovery → escalation → mitigation → resolution.]

### Root cause
[The actual cause, not the symptom.]

### Contributing factors
[What made this possible or worse — process, tooling, coverage gaps.]

### Immediate fix
[Already deployed or pending — what it does.]

### Prevention steps
[Ordered, ownable actions. Each with: what it prevents, who owns it.]

### Done when
[The conditions under which this incident is considered closed.]
---

### Shape E — Chore / Docs / Test / Infra

Use Shape A but omit "Current state" and simplify to:
- Overview
- Steps with commits
- Done when

---

## Step 4 — Critique before presenting

Before showing the plan to the user, internally check:

- Is any step too large to commit independently?
- Does any step assume something not confirmed in the codebase?
- Is there a simpler path to the same outcome?
- Does any step violate single responsibility or cross the zone's
  existing architectural / ownership boundaries?
- Is there a simpler structure or topology that reaches the same outcome?
- For changes with real design weight: should this have gone through
  `/sd-design` or `/lld-design` first?
- For hotfix/security: is the rollback actually executable?

Revise if needed. Then present.

End every plan with exactly this line:

"Review the plan above. Reply 'go' to start step 1, or tell me
what to change."

When the user replies 'go': call ExitPlanMode, then begin step 1.

After all steps are complete and "Done when" is confirmed, stop and
report what changed.

Blueprint plans and implements — it does not commit, push, or open
PRs. Contribution is a separate, deliberate step. When the work is
ready to publish, run `/contribute`.
