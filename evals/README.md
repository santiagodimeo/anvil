# evals

Evaluation patterns for AI output quality.

## Why this matters

Commands and prompts drift — what worked well in March may hallucinate
in June. Evals make quality measurable so regressions are caught before
they become habits.

## Planned

### Command evals
For each command (`/focus`, `/forge`, etc.):
- A set of test repos with known characteristics
- Expected output structure (presence of required sections, no hallucinated files)
- Correctness checks (did it find the real entry point? did it flag the real smell?)

### Hook evals
For `validate-commit-style.sh`:
- A suite of valid and invalid commit messages
- Expected exit codes and stderr output
- Edge cases: heredoc format, emoji, missing scope

### Regression suite
A lightweight CI job that runs a set of prompts against the Claude API
and asserts on output structure. Not testing for exact text — testing for
shape, completeness, and absence of known failure modes.

## Structure (to be filled)

```
evals/
├── commands/       # Per-command evaluation suites
├── hooks/          # Hook correctness tests
├── regression/     # CI-runnable regression suite
└── fixtures/       # Test repos and fixture data
```
