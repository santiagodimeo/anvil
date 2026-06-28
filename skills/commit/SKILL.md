---
name: commit
description: Stage related changes into logical commits and write conventional type(scope) imperative messages. Use when committing work that may span more than one logical unit.
when_to_use: When committing changes, especially if the working tree mixes unrelated edits.
allowed-tools: Bash(git *)
---

# Commit

Turn a working tree into clean, logically-grouped commits.

## Steps

1. Run `git status --short` and `git diff --stat HEAD`. Read the changed files.
2. Group changes by logical unit — do not assume all changes belong in one commit. If there is more than one unit, use AskUserQuestion to confirm the split before staging anything.
3. For each unit: stage only its files (`git add [specific files]`), confirm the message with AskUserQuestion, then `git commit`.
4. The commit-style hook enforces the format; match it the first time so commits are not rejected.

## Message format

<!-- @include references/commit-style.md -->

## Valid types

<!-- @include references/work-types.md -->
