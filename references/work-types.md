# Work types

The canonical task and commit taxonomy. This is the single source — the
classifier, the commit-style hook, the planner, and every command read from
here. Do not redefine these elsewhere.

## Code changes
- **feat** — new capability or behaviour
- **fix** — bug that affects existing behaviour
- **hotfix** — critical fix, needs immediate deploy
- **perf** — performance improvement, no behaviour change
- **refactor** — internal restructure, no behaviour change
- **security** — vulnerability or hardening concern

## Non-code
- **chore** — tooling, deps, config, CI
- **docs** — documentation only
- **test** — adding or fixing tests only
- **infra** — infrastructure or deployment

## Strategic
- **research** — open investigation, no defined output yet
- **spike** — time-boxed proof of concept with a hypothesis
- **rfc** — proposal requiring a team decision
- **postmortem** — incident review and prevention
