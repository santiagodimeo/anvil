---
name: classify-work
description: Classify a task or change into the canonical work-type taxonomy (feat, fix, refactor, security, chore, etc.) so commits, branches, and plans share one consistent type. Use when about to commit, plan, or open a PR and the type is not yet decided.
when_to_use: Before committing, planning, or opening a PR when the work's type is unclear.
---

# Classify work

Pin the work to exactly one canonical type before committing, planning, or opening a PR.

## Steps

1. Read the diff or task description to form a hypothesis.
2. Use AskUserQuestion to confirm the type, presenting the taxonomy below. Let the user type a keyword or describe it for you to classify.
3. Return the single chosen type. Downstream steps (commit message, PR title, branch prefix) all derive from it.

## The taxonomy

<!-- @include references/work-types.md -->
