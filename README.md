# anvil

How I work with Claude Code. Four commands, three human gates, and a hard rule
about what belongs in a conversation versus what belongs in a file.

The premise: automate the mechanical, keep the human on the engineering
judgment. Claude branches, commits, opens PRs, runs CI, reviews code, and hunts
vulnerabilities. I decide what to build, whether the plan is right, and whether
it ships.

## The loop

```
/map        understand any repo. Read-only, cached in .map/.
/spec       rough idea → spec.md, conversationally.        ← I approve
/blueprint  plan mode → plan → approve → it runs.          ← I approve
/ship       branch → commits → PR → CI → review gauntlet.  ← I merge
```

`/spec` is optional — small, obvious work goes straight to `/blueprint`.
`/blueprint` is one command, not two: native plan mode already gates
approve-then-execute, so a separate build step would be a second gate with no
new judgment in it.

`/ship` doesn't reimplement review. It runs the native `/code-review` and
`/security-review` alongside a dependency audit and lint, and reports blockers
only.

## Altitude

The rule the rest of it is built around, in `references/altitude.md` and applied
to every session:

> Report at the level the reader works at — architecture, system design, data
> model. Not files, not lines.

File-and-line detail is real and useful, so it goes where it's useful: in the
plan, in the PR body, in a `.map/` page. Not in the terminal, unless I asked.
Findings that aren't what I asked about go to a findings file and surface once,
at ship time.

## `/map`

Land in a repo, run it, understand the place. First run writes:

```
.map/
  architecture.md       topology, entry points, external deps, request flow
  system-design.md      the decisions actually made, and their tradeoffs
  low-level-design.md   the objects that matter and who owns what state
  data.md               entities and relations
  meta.json             build sha + core paths, for staleness detection
  work/                 per-task spec.md, plan.md, findings.md
```

Chat gets a digest — what moved recently, what's in flight product-wise — not
the files. Coming back later, it asks one question (full picture, or just what's
new?), defaults to what's new, and flags the map as stale if core paths have
moved since it was built.

`.map/` is ignored through git's global excludes (`~/.config/git/ignore`), never
the repo's own `.gitignore`. Nothing to explain to a teammate.

## Skills

Mechanical actions — invoked directly (`/name`) or used by the commands:

```
branch-guard   get onto a gitflow branch before work starts
branch-rescue  move accidental main commits onto a feature branch
classify-work  pin a change to one canonical work type
commit         logical commits with conventional messages
create-pr      open a PR with the Summary / Files changed / Test plan body
merge-pr       check, merge, clean up the branch
```

`branch-rescue`, `create-pr`, and `merge-pr` are user-only
(`disable-model-invocation`) — they never auto-fire.

## Hooks

| Hook | Trigger | What it does |
|------|---------|-------------|
| `validate-commit-style.sh` | `PreToolUse: Bash` | Enforces `type(scope): imperative` commit messages |
| `validate-branch-name.sh` | `PreToolUse: Bash` | Enforces `type/short-description` gitflow branch names |

Wire them into `~/.claude/settings.json`:

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

## Working in any repo

Every command reads what the repo already declares — `.claude/project.json`,
`.claude/skills/`, `CLAUDE.md`, CI config, package scripts — and defers to it. A
work repo with its own pipeline gets its own pipeline. A fresh personal project
gets sane defaults, with the assumption stated in one line so it's correctable.
anvil fills gaps; it doesn't override.

## Install

```bash
./build.sh
cp settings/settings.json.example ~/.claude/settings.json     # then fill in credentials
cp settings/settings.local.json.example ~/.claude/settings.local.json
```

`build.sh` inlines `references/` and `templates/` into the commands and skills,
installs those plus `hooks/` into `~/.claude`, and syncs the global rules into
the managed block of `~/.claude/CLAUDE.md`. Re-run after any edit — installed
files are generated, so edit the sources here, never `~/.claude`.

To scope anvil to one directory tree, point `CLAUDE_CONFIG_DIR` at a dedicated
config dir before running `build.sh` and when launching Claude Code there.

`settings/*.example` are sanitized — never commit the filled-in versions.

## v1

Tagged `anvil-v1`. Fourteen commands, each a long protocol that printed its
output into the terminal. It worked, and I stopped reading it. The rebuild is
about what reaches me, not what Claude can do.
