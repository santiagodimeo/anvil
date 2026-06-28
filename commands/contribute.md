# Contribute — assess work state, fix branch, commit, and open a PR
# Usage: /contribute
# Run when your work is ready (or nearly ready) to ship.
# The integrated ship flow. Each step also exists as a standalone skill:
# branch-rescue, classify-work, commit, create-pr, merge-pr.

You are running the contribution workflow for the current working directory.

Use TodoWrite now to create a checklist of all steps so progress is visible.

---

## Step 1 — Assess current state

Run these in parallel:

- `git status --short`
- `git branch --show-current`
- `git log --oneline -10`
- `git diff --stat HEAD`
- `git stash list`

Build a mental picture: current branch, uncommitted changes (staged, unstaged,
untracked), commits ahead of the remote or ahead of main/develop, anything
stashed. Present a one-paragraph summary before proceeding.

---

## Step 2 — Branch awareness & rescue

<!-- @include references/branch-awareness.md -->

If on `main`/`master` with commits ahead or uncommitted changes, rescue them
before continuing:

- **Commits ahead** of origin (`git log origin/main..HEAD --oneline`): create a
  branch from HEAD (`git checkout -b [name]`), reset the base
  (`git checkout main && git reset --hard origin/main`), then return to the branch.
- **Only uncommitted changes**: `git stash` → `git checkout -b [name]` → `git stash pop`.

Ask for the branch name (gitflow format) before either path. Confirm the rescue.

---

## Step 3 — Classify the work

Run `git diff main...HEAD --stat` (or the develop base) and read the changed
files. Use AskUserQuestion to confirm the type from the taxonomy below; wait for
the answer.

<!-- @include references/work-types.md -->

---

## Step 4 — Review & split uncommitted changes

If there are uncommitted changes, read each changed file and group by logical
unit — do not assume all changes belong in one commit. Use AskUserQuestion:
commit all as one, or split? If split, ask which files belong in each commit
before staging anything.

---

## Step 5 — Commit

For each unit: stage only its files (`git add [files]`), confirm the message with
AskUserQuestion, then `git commit`. Match the format below the first time — the
commit-style hook enforces it.

<!-- @include references/commit-style.md -->

---

## Step 6 — Reword non-conforming commits

Run `git log main...HEAD --oneline` (or the develop base). If any message does
not match the format, list them and ask whether to reword
(`git commit --amend` / `git rebase -i`). Propose corrected messages one at a
time and confirm before rewriting.

---

## Step 7 — Determine the PR base branch

<!-- @include references/gitflow.md -->

---

## Step 8 — Push the branch

Run `git remote get-url origin` for the URL. Use AskUserQuestion to confirm
before `git push -u origin [branch]`. If the push is rejected (non-fast-forward),
do NOT force-push without asking.

---

## Step 9 — Draft the PR

Read the branch commits (`git log [base]...HEAD --oneline`) and diff, then the
changed files. Draft the title and body from the templates below, show the draft
with AskUserQuestion ("Open PR" / "Edit"), and revise until confirmed.

### Title

<!-- @include templates/pr-title.md -->

### Body

<!-- @include templates/pr-body.md -->

---

## Step 10 — Open the PR

```
gh pr create --title "[title]" --body "$(cat <<'EOF'
[body]
EOF
)" --base [base]
```

Output the PR URL.

---

## Step 11 — Confirm

End with a single line:

"PR open: [url]"

Nothing else.
