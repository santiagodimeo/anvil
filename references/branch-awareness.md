# Branch awareness

Run `git branch --show-current 2>/dev/null` and note the branch. If this is not
a git repo, skip this entirely.

Use AskUserQuestion (customise the message to the actual branch name):

- **main / master** → "⚠️ You're on `[branch]`. Gitflow convention is to work on
  feature/, fix/, or hotfix/ branches. Continue here, or create / switch to a
  branch first?"
- **develop** → "You're on `develop`. Working directly here, or spin off a
  feature branch?"
- **any other branch** → "You're on `[branch]`. Any in-progress work here I
  should know about? Is this the right branch for this work?"

Options: "Continue here" / "Create or switch to another branch"

If the user wants to create or switch branches, help them before proceeding
(name per the gitflow conventions).
