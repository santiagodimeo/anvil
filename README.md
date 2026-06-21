# anvil

The commands, hooks, and settings that shape how I write, review, and ship software with Claude Code. Each command is a protocol, not a prompt — each hook a gate, not a suggestion.

## Commands

Ship workflow — linear by design:

```
/forge      → design and scaffold a new program from scratch
/onboard    → understand a new codebase from zero
/focus      → map a zone before changing it
/blueprint  → plan the implementation
/contribute → commit, branch, and open a PR
/audit      → codebase health check, no task in mind
/socratic   → guided dialogue when direction is unclear
```

Study & design — reason through a system or component, or learn a concept:

```
/sd-design  → architecture for a real feature (no code)
/sd-study   → reason through a system's architecture, or learn an SD concept
/lld-design → design and scaffold classes for a real component
/lld-study  → reason through a component's class design, or learn an OO concept
/dsa-study  → reason through algorithmic code, or learn a pattern
```

> Study/design commands cite a personal knowledge base via a `$KB_ROOT`
> placeholder (e.g. `$KB_ROOT/system-design`). Point it at your own notes.

## Hooks

| Hook | Trigger | What it does |
|------|---------|-------------|
| `validate-commit-style.sh` | `PreToolUse: Bash` | Enforces `type(scope): imperative` commit messages |

Wire it into `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash", "hooks": [{ "type": "command", "command": "~/.claude/hooks/validate-commit-style.sh" }] }
    ]
  }
}
```

## Install

```bash
cp commands/*.md ~/.claude/commands/
cp hooks/*.sh ~/.claude/hooks/ && chmod +x ~/.claude/hooks/*.sh
cp settings/settings.json.example ~/.claude/settings.json          # then fill in credentials
cp settings/settings.local.json.example ~/.claude/settings.local.json
```

`settings/*.example` are sanitized templates — never commit the filled-in `settings.json` or `settings.local.json`.
