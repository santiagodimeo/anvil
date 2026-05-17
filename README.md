# swe-ai-stack

A personal SWE AI framework — Claude Code commands, hooks, and tooling that define how I write, review, and ship software.

## What's here

| Folder | Purpose |
|--------|---------|
| `commands/` | Claude Code slash commands — the core workflow (focus → blueprint → contribute) |
| `hooks/` | Claude Code hooks — automated enforcement at tool boundaries |
| `settings/` | Sanitized settings templates — copy and fill in credentials |
| `clawdbot/` | Bot and automation scripts built on the Claude API |
| `mcp/` | Custom MCP servers and config for context injection |
| `agents/` | Multi-agent patterns and orchestration templates |
| `prompts/` | Reusable system prompts and prompt engineering templates |
| `evals/` | Evaluation patterns for AI output quality |
| `docs/` | Design decisions and how this stack fits together |

## Commands

The command workflow is linear by design:

```
/forge      → design and scaffold a new program from scratch
/onboard    → understand a new codebase from zero
/focus      → map a zone before changing it
/blueprint  → plan the implementation
/contribute → commit, branch, and open a PR
/audit      → codebase health check, no task in mind
/socratic   → guided dialogue when direction is unclear
/areweclean → git status sweep across all local repos
```

### Install

Copy the contents of `commands/` to `~/.claude/commands/` (global) or `.claude/commands/` (project-local):

```bash
cp commands/*.md ~/.claude/commands/
```

## Hooks

| Hook | Trigger | What it does |
|------|---------|-------------|
| `validate-commit-style.sh` | `PreToolUse: Bash` | Enforces `type(scope): imperative` commit message format |

### Install

```bash
cp hooks/validate-commit-style.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/validate-commit-style.sh
```

Wire it in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "type": "command", "command": "~/.claude/hooks/validate-commit-style.sh" }]
      }
    ]
  }
}
```

## Settings

Copy and fill in credentials:

```bash
cp settings/settings.json.example ~/.claude/settings.json
cp settings/settings.local.json.example ~/.claude/settings.local.json
```

Never commit `settings.json` or `settings.local.json` — they contain real credentials.

## Philosophy

This stack is built around one idea: **AI works best when it has clear structure to follow, not just instructions to interpret.** Each command is a protocol, not a prompt. Each hook is a gate, not a suggestion.

The workflow mirrors how good engineers actually work:
1. Understand before touching (`/focus`, `/onboard`)
2. Plan before coding (`/blueprint`, `/socratic`)
3. Ship with discipline (`/contribute`)
4. Review periodically (`/audit`, `/areweclean`)
