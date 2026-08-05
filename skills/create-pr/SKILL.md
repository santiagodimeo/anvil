---
name: create-pr
description: Draft and open a pull request with a conventional title and a Summary / Files changed / Test plan / Out of scope body, targeting the correct base branch. User-invoked only — never auto-fire.
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh *)
---

# Create PR

Open a reviewable pull request from the current branch.

## Steps

1. Determine the base branch from the current branch name (rules below). If ambiguous, ask.
2. Read the branch's commits (`git log [base]...HEAD --oneline`) and diff (`git diff [base]...HEAD --stat`), then the changed files, to understand the actual change.
3. Resolve the ticket key, if any, from the branch name, the commits, or the tracker. No tracker means the **Ticket** section is dropped entirely — heading included.
4. Push if needed: `git push -u origin [branch]`. If rejected (non-fast-forward), do NOT force-push without asking.
5. Draft title and body from the templates below and open it:
   ```
   gh pr create --title "[title]" --body "$(cat <<'EOF'
   [body]
   EOF
   )" --base [base]
   ```
   No approval gate on the body — a PR is editable, and the URL comes back
   immediately. Confirm first only when the base branch is the production
   branch.
6. Output only the PR URL.

## Title

<!-- @include templates/pr-title.md -->

## Body

<!-- @include templates/pr-body.md -->

## Base-branch rules

<!-- @include references/gitflow.md -->
