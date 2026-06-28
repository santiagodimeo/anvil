---
name: merge-pr
description: Review a pull request's checks and reviews, merge it with the repo's strategy, and clean up the branch. User-invoked only — never auto-fire.
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh *)
---

# Merge PR

Land a pull request safely and tidy up after it.

## Steps

1. Identify the PR for the current branch: `gh pr view --json number,title,state,mergeStateStatus,reviewDecision,statusCheckRollup`.
2. Surface blockers before doing anything:
   - Failing or pending checks (`statusCheckRollup`)
   - `reviewDecision` not `APPROVED`
   - `mergeStateStatus` of `BLOCKED`, `DIRTY`, or `BEHIND`
   If any are present, report them and use AskUserQuestion to confirm whether to proceed or stop.
3. Choose the merge strategy. Default to `--squash` unless the repo clearly uses merge commits or rebase; confirm with AskUserQuestion if unsure.
4. Merge and clean up: `gh pr merge --[strategy] --delete-branch`.
5. If the local branch remains, return to the base branch and prune:
   `git checkout [base] && git pull && git branch -d [branch]`.
6. Confirm with a single line: the merged PR number and the branch that was deleted.

Never merge a PR with failing required checks without explicit confirmation.
