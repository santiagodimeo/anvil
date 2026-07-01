# Design handoff — {{PROJECT_NAME}}

This directory holds the **design handoff bundle** for {{PROJECT_NAME}} — the visual
source of truth a coding agent implements against.

## How to fill it

Mock the UI in [claude.ai/design](https://claude.ai/design), then export the bundle here.
An exported bundle contains:

- `chats/` — the conversation transcripts. **Read these first** — they carry the intent,
  not just the output.
- `project/` — the HTML/CSS/JS prototypes, assets, and shared components.

## How a coding agent should use it

- Treat the prototypes as the **visual spec**, not production code. Recreate them
  pixel-faithfully in whatever the target stack is — match the output, not the prototype's
  internal structure.
- Read the HTML/CSS directly for dimensions, colors, and layout rules. Don't render in a
  browser or screenshot unless asked.
- If anything is ambiguous, confirm before implementing.

_Empty until you export a design. Delete this slot if the project has no UI._
