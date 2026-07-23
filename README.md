# anvil

The commands, skills, hooks, references, and settings that shape how I write, review, and ship software with Claude Code. Each command is a protocol, not a prompt — each hook a gate, not a suggestion. Shared rules live once in `references/` and `templates/`, inlined into commands and skills at build time.

## Commands

Ship workflow — linear by design:

```
/forge      → design and scaffold a new program from scratch
/groundwork → lay the AI-native project layer (charter, roadmap, .claude/) onto a repo
/onboard    → understand a new codebase from zero
/focus      → map a zone before changing it
/survey     → map a zone against the repo's own standards
/blueprint  → plan the implementation
/draft      → plan it against the repo's own standards
/contribute → commit, branch, and open a PR
/release    → changelog from commits grouped by type
/audit      → codebase health check, no task in mind
/socratic   → guided dialogue when direction is unclear
```

> `/survey` and `/draft` are the project-aware pair. They read whatever the repo
> declares — `.claude/project.json`, `.claude/skills/`, `CLAUDE.md` — derive the
> base branch, work type, verify command and ship path from it, print those as
> stated assumptions, and ask only the questions a repo can't answer. Where a
> tracker is configured they take a ticket key directly (`/survey EUP-304`), and
> they hand off to the repo's own pipeline rather than always to `/contribute`.
> In a repo that declares nothing they fall back to `/focus` and `/blueprint`
> behaviour, which remain the generic pair.

Design — reason about a real feature or component (no code, or skeletons only):

```
/sd-design  → architecture for a real feature (no code)
/lld-design → design and scaffold classes for a real component
```

Artifacts — generate something from what already exists:

```
/erd        → entity-relationship diagram from a live DB → .excalidraw
```

> Design commands cite a personal knowledge base via a `$KB_ROOT` placeholder
> (e.g. `$KB_ROOT/system-design`). Point it at your own notes. The learning
> commands (sd-study, lld-study, dsa-study) have graduated to a separate
> interactive tutor — anvil is design, build, and ship only.

## Skills

Reusable actions — invoked à la carte (`/name`) or walked by the ship commands:

```
branch-guard   → nudge onto a gitflow branch before work begins
branch-rescue  → move accidental main commits onto a feature branch
classify-work  → pin a change to one canonical work type
commit         → logical commits with conventional messages
create-pr      → open a PR with a structured What/Why/Result body
merge-pr       → review checks and merge, then clean up the branch
```

`branch-rescue`, `create-pr`, and `merge-pr` are user-only (`disable-model-invocation`) — they never auto-fire.

## Hooks

| Hook | Trigger | What it does |
|------|---------|-------------|
| `validate-commit-style.sh` | `PreToolUse: Bash` | Enforces `type(scope): imperative` commit messages |
| `validate-branch-name.sh` | `PreToolUse: Bash` | Enforces `type/short-description` gitflow branch names |

Wire it into `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash", "hooks": [
        { "type": "command", "command": "~/.claude/hooks/validate-commit-style.sh" },
        { "type": "command", "command": "~/.claude/hooks/validate-branch-name.sh" }
      ] }
    ]
  }
}
```

## Install

```bash
./build.sh                                                    # expand shared text + install into ~/.claude
cp settings/settings.json.example ~/.claude/settings.json     # then fill in credentials
cp settings/settings.local.json.example ~/.claude/settings.local.json
```

`build.sh` is the single entry point: it inlines `references/` and `templates/`
into the commands and skills, installs those plus `hooks/` into `~/.claude`,
copies `scaffold/` to `~/.claude/scaffold/`, and syncs the global rules block into
`~/.claude/CLAUDE.md`. Re-run it after any edit — the installed files are
generated, so never hand-edit them; edit the sources here.

`scaffold/` mirrors the per-project layout `/groundwork` materialises into a repo
(charter, `docs/product/roadmap.md`, project-local `.claude/`, and optional
autopilot / design / reference / CI). Unlike `templates/` (format snippets inlined
into commands at build time), these are whole files copied and placeholder-filled
into the target project at runtime.

To scope anvil to one directory tree (e.g. personal projects only), point
`CLAUDE_CONFIG_DIR` at a dedicated config dir before running `build.sh` and when
launching Claude Code there.

`settings/*.example` are sanitized templates — never commit the filled-in `settings.json` or `settings.local.json`.
