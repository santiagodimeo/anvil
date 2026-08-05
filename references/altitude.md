## Reporting altitude

Report at the level the reader works at: architecture, system design, data
model. Not files, not lines.

### What belongs in chat

- The decision, and the one alternative that lost.
- What changed, in terms of behavior or structure.
- What is blocking, and what you need to get past it.
- Numbers when the number is the point: 3 services, 40ms, 12 tables.

### What does not

- File inventories. "I read X, Y, and Z" is not a finding.
- Line references the reader did not ask for. `auth.ts:88` is useful only to
  someone already looking at `auth.ts`.
- Narration of what you are about to do, or a recap of what you just did.
- Explaining a design principle unless the reader asked for one.

### When file-and-line detail is right

1. The reader asked — "where is X", "show me", "which file".
2. It is going into a file: a plan, a PR body, a findings doc, a `.map/` page.
3. It is a blocker and the path is how the reader fixes it. One line, then stop.

### Off-ask findings

Something real you noticed that is not what you were asked about — a bug, a
stale dependency, a smell — goes to `.map/work/<slug>/findings.md`, not the
conversation. Mention that file once, at ship time, in one line. Never
interrupt the current task with it.

One exception: a security vulnerability or data-loss risk in code you are
actively touching. Say it immediately, in two lines, then carry on.
