# Spec — turn a rough idea into something buildable
# Usage: /spec [the idea, a ticket key, or nothing]
# Optional. Small, obvious work goes straight to /blueprint.

You are helping shape what to build, before anyone decides how. Product level
only — no implementation, no file names, no architecture. That's `/blueprint`.

<!-- @include references/altitude.md -->

---

## Step 0 — Is this worth a spec?

If the work is one obvious change with a clear outcome, say so in one line and
point at `/blueprint`. Don't manufacture a spec for a two-line fix.

A spec earns its place when the *what* is genuinely unsettled: the outcome is
fuzzy, the scope has no edge yet, or there's more than one reasonable product
answer.

---

## Step 1 — Read before asking

Read `.map/` if it exists, and the ticket if `$ARGUMENTS` looks like a key and a
tracker is wired up. Never ask something these already answer.

<!-- @include references/repo-signals.md -->

---

## Step 2 — The conversation

Ask at most three questions at a time, via AskUserQuestion, and only ones the
repo and the ticket can't answer. These are judgment calls, not lookups:

1. **The outcome** — what's true for a user, or for the system, once this ships?
2. **The edge** — what's deliberately not in this? The answer becomes *Out of
   scope*, and it's the question that most often saves a week.
3. **Done** — what would you check to believe it works?

Follow the answers where they go. This is a conversation, not a form: if an
answer opens a real question, ask it; if it closes one, drop it. Push back when
the scope is bigger than the outcome justifies — naming a smaller version that
delivers most of the value is the most useful thing you can do here.

---

## Step 3 — Write it

Write `.map/work/<slug>/spec.md`, where `<slug>` is the ticket key when there is
one, otherwise a short kebab-case name for the work.

```markdown
# <title>

## Problem
[What's wrong or missing today, and who it's costing. Two or three sentences.]

## Outcome
[What's true once this ships. Observable, from outside the code.]

## Scope
[What's in. Bullets, one line each.]

## Out of scope
[What's deliberately not in, and where it gets handled instead.]

## Done when
[Concrete and checkable. Not "works well" — the thing you'd actually verify.]

## Open
[Anything still undecided, and who decides it. Delete this section if empty.]
```

Then, in chat, three lines: where the file is, the one decision that's still
open if there is one, and that `/blueprint` is next. Don't print the spec — they
just answered the questions in it.

---

## Step 4 — Their gate

They edit the file. When they come back, re-read it before doing anything else —
what's in the file wins over what was said in conversation.
