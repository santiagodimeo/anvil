#!/usr/bin/env bash
set -uo pipefail

input=$(cat)

command=$(echo "$input" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_input', {}).get('command', ''))
except:
    print('')
" 2>/dev/null || echo "")

# Only check branch-creation commands
if ! echo "$command" | grep -qE 'git (checkout -b|switch -c|branch )'; then
  exit 0
fi

# Extract the new branch name
branch=$(echo "$command" | grep -oE 'git (checkout -b|switch -c) [^ ;&|]+' | head -1 | awk '{print $NF}')

# git branch NAME (creation form — ignore flags like -d/-D/--list)
if [ -z "$branch" ]; then
  branch=$(echo "$command" | grep -oE 'git branch [^-][^ ;&|]*' | head -1 | awk '{print $NF}')
fi

# Can't extract a name — don't block on uncertainty
if [ -z "$branch" ]; then
  exit 0
fi

# Base branches themselves are always allowed
if echo "$branch" | grep -qE '^(main|master|develop)$'; then
  exit 0
fi

pattern='^(feature|fix|hotfix|release|perf|refactor|chore|security|docs|test|infra)/[a-z0-9._-]+$'

if echo "$branch" | grep -qE "$pattern"; then
  exit 0
fi

echo "Branch name does not match the gitflow convention." >&2
echo "" >&2
echo "  Got:      $branch" >&2
echo "  Expected: type/short-description" >&2
echo "" >&2
echo "  Prefixes: feature fix hotfix release perf refactor chore security docs test infra" >&2
echo "  Example:  feature/oauth-login" >&2
exit 2
