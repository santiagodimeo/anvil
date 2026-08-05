## Summary
[Two or three sentences. What changed and why, at a level a PM could follow.
The problem it solves, not a restatement of the diff.]

## Files changed
- `path/to/file.ts` — [one or two sentences on what changed here and why.]
- `path/to/other.ts` — [same.]

## Test plan
Unit: `[the repo's verify command]` — [what the new or changed tests cover.]
Manual:
1. [step]
2. [what you should see]

## Out of scope
[What this deliberately doesn't do, and where it gets handled instead. One or
two lines.]

## Ticket
[KEY-123 — or omit this whole section, heading included, when there's no tracker.]

---
Rules:
- Files changed lists files a reviewer must actually read. Skip lockfiles,
  generated output, and mechanical renames — say "plus N mechanical renames"
  instead.
- Omit a section entirely rather than writing "N/A" or leaving it empty. That
  goes for Ticket when there's no tracker, and for Out of scope when the change
  has no meaningful boundary.
- Test plan needs at least one of unit or manual. Both when both exist.
- No emoji. No "This PR" opener. Don't restate the title. No filler like
  "As part of this work".
- Present tense for what the change does ("adds", "now returns"), past tense for
  the problem it fixes ("was dropping the session").
