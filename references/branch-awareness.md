## Branch awareness

Run `git branch --show-current`. Not a git repo? Skip this entirely.

**On `main`, `master`, or `develop`** — create the branch and say one line.
Don't ask. The name comes from the derived work type plus a slug of the task,
per the gitflow conventions.

```
Branched to feature/oauth-login off develop.
```

**On any other branch** — it's already a working branch. Say nothing, continue.

### When to actually ask

Only when acting would be wrong, not merely uncertain:

- The branch has uncommitted work unrelated to this task.
- The work type maps to two plausible bases — a `fix` that might be a `hotfix`
  targeting `main` rather than `develop`.

One question, then proceed.
