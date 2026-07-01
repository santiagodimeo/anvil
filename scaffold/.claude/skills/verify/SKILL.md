---
name: {{PROJECT_SLUG}}-verify
description: Essential testing gate for {{PROJECT_NAME}} — typecheck, unit tests, and a build smoke. Returns PASS/FAIL with the failing output. Not exhaustive; catches breakage, not every edge.
allowed-tools: Bash
---

# {{PROJECT_SLUG}}-verify

The automated quality gate. **Essential, not exhaustive** — it proves the project still
type-checks, the unit tests pass, and it still builds. Runtime / UI behavior is out of
scope here (smoke-built, not driven).

## Steps

1. Run the bundled gate:
   ```
   {{VERIFY_CMD}}
   ```
2. If any stage fails, capture the **failing output only** (last ~30 lines of the broken
   stage) — don't dump full logs.

## Output

Return one of:

- `PASS — <gate stages> ✓`
- `FAIL — <stage>: <one-line cause>` followed by the captured failing output.

Nothing else. The caller decides whether to fix-and-retry (cap 2) or stop.

## Notes

- Never edit code from inside this skill — it only measures.
- If dependencies are missing, install them first, then run the gate.
- Keep it fast: no coverage runs, no e2e here.
