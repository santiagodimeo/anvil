# Release — changelog from commits grouped by type
# Usage: /release [range — optional, e.g. v1.2.0..HEAD]
# Generates grouped release notes from git history. Read-only until you choose to save.

You are generating release notes for: $ARGUMENTS

Use read-only git commands throughout. Do not write any file until Step 5.

---

## Step 1 — Determine the range

- If $ARGUMENTS names a range (e.g. `v1.2.0..HEAD`), use it.
- Else find the last tag: `git describe --tags --abbrev=0 2>/dev/null`, and use
  `[last-tag]..HEAD`.
- If there are no tags, use the full history and note that the range is "all history".

## Step 2 — Collect commits

Run `git log [range] --no-merges --pretty=format:'%h %s'`.

## Step 3 — Group by type

Parse each subject as `type(scope): description`. Group by type using the
canonical taxonomy below, in this display order; skip empty groups. Map types to
human headings:

- `feat` → **Features**
- `fix`, `hotfix` → **Fixes**
- `perf` → **Performance**
- `security` → **Security**
- `refactor` → **Refactors**
- `docs` → **Documentation**
- `chore`, `infra`, `test` → **Maintenance**
- anything that does not match `type(scope):` → **Other**

<!-- @include references/work-types.md -->

## Step 4 — Emit

Output markdown:

```
## [version or range] — [today's date]

### Features
- **scope:** description (`hash`)
...
```

Rules:
- Drop the `type` prefix from each line — it is the heading.
- Bold the scope as a prefix when present; omit it when absent.
- One line per commit, the commit's description verbatim. No emoji.

## Step 5 — Offer to save

Use AskUserQuestion: prepend to `CHANGELOG.md`, print only, or emit as a tag
annotation message. Only write a file if the user picks that option.
