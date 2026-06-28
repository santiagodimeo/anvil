---
name: branch-guard
description: Check the current git branch follows gitflow before work begins, and offer to create or switch to a feature branch when on main, master, or develop. Use at the start of any task that will modify code.
when_to_use: Starting work on main/master/develop, or before planning or implementing a change that will touch the repo.
allowed-tools: Bash(git *)
---

# Branch guard

Ensure work happens on a gitflow-appropriate branch before it begins.

<!-- @include references/branch-awareness.md -->

## Naming & base conventions

<!-- @include references/gitflow.md -->
