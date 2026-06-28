# Gitflow conventions

## Branch naming
`type/short-description` — e.g. `feature/oauth-login`, `fix/null-session`,
`hotfix/payment-crash`. Lowercase, hyphenated, no spaces.

Valid prefixes: `feature` `fix` `hotfix` `release` `perf` `refactor`
`chore` `security` `docs` `test` `infra`.

## PR base-branch inference
- `hotfix/*` → base `main`
- `release/*` → base `main`
- everything else (`feature/*`, `fix/*`, `perf/*`, `refactor/*`, `chore/*`, …)
  → base `develop`

If the base is ambiguous, ask which to target before pushing or opening a PR.
