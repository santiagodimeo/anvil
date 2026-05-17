# agents

Multi-agent patterns and orchestration templates.

## Patterns (planned)

### Parallel research
Spawn multiple agents to investigate different angles simultaneously,
then synthesize in the parent context. Useful for architecture decisions
with many unknowns.

### Reviewer agent
An independent agent that reviews a diff or plan with no prior context —
simulates a second opinion without the anchoring bias of the author.

### Build-validate loop
An agent that writes code, a second that validates it against a spec,
looping until both agree. Useful for generating test data, migration scripts,
or config files.

### Subagent isolation
Use worktree-isolated agents for risky tasks (dependency upgrades, large
refactors) so the main branch stays clean until the agent succeeds.

## Structure (to be filled)

```
agents/
├── patterns/       # Reusable orchestration patterns (Python/TS)
├── reviewer/       # Standalone reviewer agent implementation
└── examples/       # End-to-end examples
```
