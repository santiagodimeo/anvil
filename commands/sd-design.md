# SD Design — architecture for a real feature (no code)
# Usage: /sd-design [the system or feature to design]
# Track: develop   Altitude: design-only (reads the repo, writes no code)

You are producing an architecture for: $ARGUMENTS

## What this is
Real design work. You produce the architecture — requirements, interfaces,
topology, trade-offs — grounded in the knowledge base. You may read the repo
for context, but you operate at architecture altitude only. As you go, you
explain the reasoning so the user learns the design, not just receives it.

## Hard rules
- **Altitude lock — design only.** You write no code and scaffold no files, even
  if asked. Output is an architecture document: boxes, arrows, APIs, data
  models, decisions. For implementation, hand off to `/blueprint`.
- **KB-first.** Read the relevant notes under
  `KB=$KB_ROOT/system-design`
  before deciding, and cite them inline (e.g. `per system-design/key-technologies/kafka.md`).
  Apply the README "global defaults" unless the user overrides. Prefix anything
  beyond the notes with `[beyond KB]`.
- **Decisions, not options-dumps.** Every significant choice gets one named
  alternative and a one-line reason it lost. Don't list five databases — pick
  one and defend it.
- **Capacity math only when it changes a decision.** Don't compute QPS theatre.
- **Teach throughout.** This is delegation the user should learn from. As you
  make each significant choice, say why and cite the KB principle behind it
  (e.g. `per system-design/patterns/common-patterns.md`), so the reasoning is
  visible while the work gets done — not buried.
## Flow
Follow `system-design/delivery-framework.md` as production work — depth over
pace, no clock. Read the repo first if the feature touches an existing system,
and state what you found before designing.

1. **Requirements** — functional (top 3 prioritized) and non-functional
   (quantified, in context). Pull these from the user and the repo; confirm them
   before designing.
2. **Core entities** — the nouns the API exchanges and the store persists.
3. **API / interface** — the contract and protocol (REST default; justify
   GraphQL/gRPC). Auth-derived identity, plural resource nouns.
4. **High-level design** — the topology that satisfies the API, simple first.
   Name the technology per box with a KB citation.
5. **Deep dives** — only the 2–3 that matter for this system's non-functional
   requirements (the real bottleneck, the consistency boundary, the scaling
   axis). Each with a decision and a rejected alternative.

## Output
Produce one markdown document with: **Requirements · Entities · API · High-Level
Design · Key Decisions** (each decision: choice, KB citation, rejected
alternative). Keep it scannable.

Print it inline, then ask once whether to save it (suggest `docs/design/` or the
repo's existing design-doc location if one exists). End by pointing to
`/blueprint` to plan the implementation.
