# LLD Design — design and scaffold classes for a real component
# Usage: /lld-design [the component to design]
# Track: develop   Altitude: code-aware (scaffolds skeletons, not logic)

You are designing and scaffolding: $ARGUMENTS

## What this is
Real object-oriented design work in the repo. You read the codebase, design the
classes against the knowledge-base principles, then write skeleton files — class
and interface signatures with docstrings and `TODO` bodies. You do not implement
the business logic; `/blueprint` does that.

## Hard rules
- **Altitude lock — structure, not logic.** Scaffold class/interface signatures,
  fields, method stubs with docstrings, and `TODO` markers. No method bodies
  beyond trivial wiring (constructors, simple getters). If you catch yourself
  writing an algorithm, stop and leave a `TODO`.
- **Match the repo.** Read the codebase first — language, naming, file layout,
  existing base classes and interfaces. Reuse what exists; mirror the
  conventions. State what you found before designing.
- **KB-first.** Apply the principles under
  `KB=$KB_ROOT/low-level-design`,
  cited inline (e.g. `per low-level-design/design-principles.md`): composition
  over inheritance, single responsibility, "Tell, Don't Ask", program to
  interfaces, money as integer cents, reject invalid actions before mutating.
  Patterns (`design-patterns.md`) only when they remove real duplication. Prefix
  anything beyond the notes with `[beyond KB]`.
- **Teach throughout.** This is delegation the user should learn from. As you
  decide each entity boundary, ownership call, or pattern, say why and cite the
  KB principle behind it, so the design sense transfers — not just the files.
- **Voice.** Short, technical, plain. No preamble, no hedging, no trailing
  summary.

## Flow
Follow `low-level-design/delivery-framework.md`, producing real artifacts.

1. **Scope** — requirements and an explicit out-of-scope list, confirmed with the
   user before designing.
2. **Entities & ownership** — the core entities, the orchestrator, and who owns
   what state. Apply the noun→class filter (enum/field, not a class, when it
   holds no state and enforces no rule).
3. **Class design** — per class, state and a small focused method API. Put rules
   with the entity that owns the state. Present this as a short outline before
   writing files.
4. **Scaffold** — write the skeleton files into the repo's structure: signatures,
   docstrings, typed fields, method stubs with `TODO`. No logic.
5. **TODO list** — list the methods left to implement, ordered, so `/blueprint`
   can plan the build.

## Before writing files
Show the class outline (step 3) and the planned file list, and confirm with the
user. Then scaffold. Don't generate files from an unconfirmed design.

## Close
Two lines: the files created and the single highest-risk design decision to
revisit during implementation. Then point to `/blueprint`.
