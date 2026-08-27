# anvil

How I work with Claude Code in my personal workspace. Five commands, three human
gates, one maintenance sweep, one personal utility, and a hard rule about what
belongs in a conversation versus what belongs in a file.

The premise: automate the mechanical, keep the human on the engineering
judgment. Claude branches, commits, opens PRs, runs CI, reviews code, and hunts
vulnerabilities. I decide what to build, whether the plan is right, and whether
it ships.

## The loop

```
/stock      what am I working with? Read-only, no cache.
/map        understand any repo. Read-only, cached in .map/.
/spec       rough idea → spec.md, conversationally.        ← I approve
/blueprint  plan mode → plan → approve → it runs.          ← I approve
/ship       branch → commits → PR → CI → review gauntlet.  ← I merge
```

`/stock` and `/spec` are both optional. A repo I already know doesn't need
`/stock`; small, obvious work goes straight to `/blueprint`.

`/blueprint` is one command, not two: native plan mode already gates
approve-then-execute, so a separate build step would be a second gate with no
new judgment in it.

`/ship` doesn't reimplement review. It runs the native `/code-review` and
`/security-review` alongside a dependency audit and lint, and reports blockers
only.

Outside the loop, across all of them:

```
/sweep      update and clean every repo in a scope.       ← I approve
/tldr       cut something long down to what I must act on.
```

`/tldr` is not an anvil command — it's a personal utility that lives directly in
each config dir and is deliberately absent from `.anvil-manifest`, so rebuilds
never touch it. Adding a `commands/tldr.md` to this repo would overwrite the
hand-written copy on the next build.

## Altitude

The rule the rest of it is built around. It lives in two places now: the
`Direction` output style, which applies it to every response in every account,
and `references/altitude.md`, which is inlined into all six commands so it
survives an output-style switch.

> Report at the level the reader works at — architecture, system design, data
> model. Not files, not lines.

File-and-line detail is real and useful, so it goes where it's useful: in the
plan, in the PR body, in a `.map/` page. Not in the terminal, unless I asked.
Findings that aren't what I asked about go to a findings file and surface once,
at ship time.

## `/stock`

The first sixty seconds in an unfamiliar repo, when the question is still what
this is and whether I care. Five sections, one screen, nothing written:

```
What this is    the kind of system, in a sentence
Stack           languages, frameworks, runtime, and what pins each claim
Layout          the directories that matter, one line of purpose each
Config          what decides how this builds, runs, and deploys
Shape           how it's organized, and the convention a newcomer trips on
```

Bar stock — the material identified before it's heated. It answers *what is
it*; `/map` answers *how does it work* and pays for that with a cache. Run
`/stock` first, `/map` if the answer makes the repo worth it.

Directory and file names appear here, which the altitude rule normally
forbids — but only for detail nobody asked for, and typing `/stock` is the ask.
The discipline is that every entry earns its line with a purpose. A bare tree is
the thing the command exists to avoid printing.

Adapted from the codebase-exploration prompt in educative's *Claude Code:
Workflows and Tools*. More of the course lands here as I work through it.

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

## `/sweep`

The only command that works across repos instead of inside one. Maintenance,
not delivery — it sits outside the loop because nothing it does moves a change
toward shipping:

```
branches    fetch --prune everywhere, fast-forward what's behind
worktrees   flag the ones left over from work that already finished
draft PRs   suggest the ones nobody is going to finish, with the reason
docker      containers holding memory for a repo I stopped working on
```

One question, ever: **where**. The options are computed at run time from
`~/.claude.json`'s project list plus a bounded disk scan, grouped by parent
folder — no directory name is hardcoded anywhere in the command. An argument
skips the question entirely.

Everything else is derived, reported, and gated. Actions land in three tiers,
split on one line — **git-local and reversible is safe; destroys data or costs a
rebuild is an ask:**

| Tier | What's in it | Gate |
|------|--------------|------|
| Safe | fast-forwards, `[gone]`-and-merged branch deletes, `worktree prune` | one approval for the batch |
| Ask | stale worktrees, draft PRs, stashes, all of Docker | numbered, I pick |
| Never | anything with uncommitted or unpushed work | reported only |

That puts every Docker prune in the ask tier. Reclaiming a build cache is free
disk and several minutes of rebuild, and that trade doesn't belong batched into
an approval about branch refs.

The report's **Left alone** section is the point of the whole thing. A sweep
that only shows what it wants to delete is asking to be trusted about
everything it didn't mention.

The one unasked mutation is `git fetch --all --prune --tags`, which can't touch
a working tree or a commit. It never pushes, rebases, resets, or force-anythings
— and a non-interactive session reports and stops without applying anything.

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

## Scope — personal work only

anvil is the personal-workspace framework. It installs into `~/.claude` and
nowhere else.

Four commands are borrowed by the work config dir, because that pipeline has no
equivalent: `/map` and `/stock` (repo understanding), `/sweep` (cross-repo
maintenance), and `/tldr` (which was never an anvil command anyway). They are
symlinked **per file**, not per directory — so they track a rebuild here without
dragging `/blueprint` and `/ship` across the boundary. Nothing else crosses.

Work at Juxtapose runs on a different pipeline (`jxp-skills`, installed per-repo)
under a separate config dir at `~/.claude-juxtapose`. Those two frameworks
disagree about who gates a merge — anvil gates on `/ship`'s review gauntlet,
jxp-skills gates on an `/audit-pr` receipt that fails closed — so they don't
share a commands directory and shouldn't.

Do not run `build.sh` against the work config dir. Within personal repos, every
command still reads what the repo declares — `.claude/project.json`, `CLAUDE.md`,
CI config, package scripts — and defers to it rather than overriding.

## Install

```bash
CLAUDE_CONFIG_DIR=~/.claude ./build.sh
cp settings/settings.json.example ~/.claude/settings.json     # then fill in credentials
cp settings/settings.local.json.example ~/.claude/settings.local.json
```

`build.sh` inlines `references/` and `templates/` into the commands and skills,
installs those plus `hooks/` into `~/.claude`, and syncs the global rules into
the managed block of `~/.claude/CLAUDE.md`. Re-run after any edit — installed
files are generated, so edit the sources here, never `~/.claude`.

**Set `CLAUDE_CONFIG_DIR` explicitly.** `build.sh` targets
`${CLAUDE_CONFIG_DIR:-$HOME/.claude}`, so running it bare from a shell where that
variable points at the work config dir installs anvil into work. Worse, a first
build against a config dir with no `.anvil-manifest` fires the one-time v1→v2
migration, which deletes `$CLAUDE_CONFIG_DIR/scaffold/`.

`settings/*.example` are sanitized — never commit the filled-in versions.

## v1

Tagged `anvil-v1`. Fourteen commands, each a long protocol that printed its
output into the terminal. It worked, and I stopped reading it. The rebuild is
about what reaches me, not what Claude can do.
