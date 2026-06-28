---
name: create-pr
description: Draft and open a pull request with a conventional title and a structured What/Why/Result body, targeting the correct base branch. User-invoked only — never auto-fire.
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh *)
---

# Create PR

Open a reviewable pull request from the current branch.

## Steps

1. Determine the base branch from the current branch name (rules below). If ambiguous, ask.
2. Read the branch's commits (`git log [base]...HEAD --oneline`) and diff (`git diff [base]...HEAD --stat`), then the changed files, to understand the actual change.
3. Push if needed: `git push -u origin [branch]`. If rejected (non-fast-forward), do NOT force-push without asking.
4. Draft the title and body from the templates below. Show the full draft with AskUserQuestion ("Open PR" / "Edit") and revise until confirmed.
5. Open it:
   ```
   gh pr create --title "[title]" --body "$(cat <<'EOF'
   [body]
   EOF
   )" --base [base]
   ```
6. Output only the PR URL.

## Title

<!-- @include templates/pr-title.md -->

## Body

<!-- @include templates/pr-body.md -->

## Base-branch rules

<!-- @include references/gitflow.md -->
