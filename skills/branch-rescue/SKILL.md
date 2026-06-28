---
name: branch-rescue
description: Move accidental commits or uncommitted changes off main or master onto a proper feature branch and reset the base back to origin. User-invoked only — never auto-fire.
disable-model-invocation: true
allowed-tools: Bash(git *)
---

# Branch rescue

Recover from working directly on `main` or `master`.

## Steps

1. Confirm the branch with `git branch --show-current`. If not on `main`/`master`, report that and stop.
2. Find commits ahead of origin: `git log origin/main..HEAD --oneline` (use `master` if that is the base).
3. **If there are commits ahead:**
   - Use AskUserQuestion: "You have N commit(s) directly on `main` that aren't pushed. I'll move them to a new branch and reset main to origin/main. New branch name?" (hint: gitflow format, e.g. `feature/short-description`)
   - `git checkout -b [branch-name]` (from HEAD)
   - `git checkout main && git reset --hard origin/main`
   - `git checkout [branch-name]`
   - Confirm: "Moved N commit(s) to `[branch-name]`. main is back to origin/main."
4. **If there are only uncommitted changes:**
   - Use AskUserQuestion to get the new branch name.
   - `git stash` → `git checkout -b [branch-name]` → `git stash pop`
   - Confirm: "Changes moved to `[branch-name]`."

Never force-push as part of a rescue without explicit confirmation.

Naming conventions:

<!-- @include references/gitflow.md -->
