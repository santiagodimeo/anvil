# Blueprint — plan it, approve it, run it
# Usage: /blueprint [ticket key, task, or feature name]
# One command: plan mode → the questions only you can answer → plan → your
# approval → execution. There is no separate build step.

Call `EnterPlanMode` now. Read-only tools only — Read, Glob, Grep, LS, LSP,
WebSearch, tracker MCP — until the plan is approved.

<!-- @include references/altitude.md -->

---

## Step 1 — Read what already exists

In parallel, and without narrating it:

- `.map/` if present. It's already-paid-for context; don't re-derive the
  architecture.
- `.map/work/<slug>/spec.md` if a spec exists for this work.
- The ticket, if `$ARGUMENTS` is a key and a tracker is wired up.

<!-- @include references/repo-signals.md -->

Print the derived block once. That's the only status output before the plan.

---

## Step 2 — Classify

<!-- @include references/work-types.md -->

Derive the type rather than asking: ticket label → branch prefix → the change
itself. Ask only if all three fail. Put it in the derived block with its source.

---

## Step 3 — Ask only what a repo can't answer

Maximum three questions, all at once, via AskUserQuestion. Never re-ask anything
in the derived block or already answered by the spec.

What's worth asking depends on the type, but it's almost always some of:

- **What does done look like** — the outcome, if no spec pinned it.
- **Constraints to design around** — frozen API, no new dependencies, perf
  budget, backward compatibility.
- **Where it comes from** — for a fix, whether they know the origin or you
  should trace it.
- **Scope edge** — is there a smaller version that delivers most of the value.

If an answer is "I don't know", go find out with read-only tools before
planning. Report what you found in two or three lines, at altitude, and give
them the chance to correct your read before you build on it.

---

## Step 4 — Think it through

For anything touching topology, data model, or class structure, do the design
thinking here — not in a separate command, and not out loud. What lands in the
plan file is the decision and the alternative that lost. What lands in chat is
nothing yet.

Shape the work to the repo's sizing limits if it declares any. If it implies
more than one PR, say how many, up front. Sizing problems belong at plan time,
not at PR time.

---

## Step 5 — Write the plan

Write `.map/work/<slug>/plan.md`. Steps, and the reasoning behind them. No
Overview, no Approach section, no Rollback boilerplate, no Done-when restating
the spec.

```markdown
# <type>(<scope>): <title>

[One paragraph: the approach, and the alternative that lost with the one-line
reason. This is the only prose
in the file.]

## Steps

### 1. <what this step accomplishes>
Change: [files, and what changes in each. No code.]
Verify: [the repo's verify command, or what proves this step worked.]
Commit: `type(scope): imperative message`

### 2. ...
```

Every step is independently committable, verifiable before the next one starts,
and minimal. Fold trivial steps into the one before — a short plan finished
beats a complete plan abandoned.

Present it with `ExitPlanMode`.

---

## Step 6 — Run it

Once approved, execute the steps in order. Branch first if needed:

<!-- @include references/branch-awareness.md -->

**Per-step chat output is three lines, hard cap:**

```
2/5 · Replaced the token verifier in src/auth.ts
      make test — passing
      Next: backfill the session table
```

That's what changed, whether verify passed, what's next. Nothing else. No diffs,
no code echo, no explanation of the change, no line numbers.

**When something breaks**, state it flat — cause and fix, no "uh oh":

```
3/5 · Failed. auth.spec.ts expects 200, got 401.
      Cause: the middleware runs before the token is attached.
      Fix: move attachToken above requireAuth. Applying.
```

Fix it and continue. Stop and ask only if the fix changes the plan's shape or
the failure means an assumption in the plan was wrong.

**When the plan turns out to be wrong** — a step reveals the approach doesn't
work — stop. Say which assumption broke, in two lines, and what you'd do
instead. Don't quietly re-plan mid-execution.

**Off-ask findings** go to `.map/work/<slug>/findings.md` as you hit them.
Don't mention them until `/ship`.

At the end, one line: what now works, and that `/ship` is next.
