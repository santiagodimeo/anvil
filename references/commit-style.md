# Commit style

Format: `type(scope): imperative verb phrase`

- All lowercase except proper nouns
- No trailing period
- Scope is the affected module, file group, or feature area
- Imperative mood: "add", "fix", "remove", "update", "extract" — not "added" or "adding"
- 72 characters max on the first line
- No emoji

Valid `type` values are defined once in [work-types.md](work-types.md):
`feat fix hotfix perf refactor security chore docs test infra research spike rfc postmortem`

Example: `feat(auth): add OAuth2 login`
