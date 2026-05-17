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

# Only check git commit commands
if ! echo "$command" | grep -qE 'git commit'; then
  exit 0
fi

msg=""

# Method 1: heredoc style (what Claude uses by convention)
if echo "$command" | grep -q "cat <<'EOF'"; then
  msg=$(printf '%s' "$command" | awk "/cat <<'EOF'/{found=1; next} /^[[:space:]]*EOF/{if(found) exit} found{sub(/^[[:space:]]+/, \"\"); print; exit}")
fi

# Method 2: -m "message"
if [ -z "$msg" ]; then
  msg=$(echo "$command" | grep -oP '(?<=-m ")[^"]+' | head -1)
fi

# Method 3: -m 'message'
if [ -z "$msg" ]; then
  msg=$(echo "$command" | grep -oP "(?<=-m ')[^']+" | head -1)
fi

# Can't extract message — don't block on uncertainty
if [ -z "$msg" ]; then
  exit 0
fi

pattern='^(feat|fix|hotfix|perf|refactor|security|chore|docs|test|infra|research|spike|rfc|postmortem)\([a-zA-Z0-9/_-]+\): .+'

if echo "$msg" | grep -qE "$pattern"; then
  exit 0
fi

echo "Commit message does not match the required format." >&2
echo "" >&2
echo "  Got:      $msg" >&2
echo "  Expected: type(scope): imperative message" >&2
echo "" >&2
echo "  Types: feat fix hotfix perf refactor security chore docs test infra" >&2
echo "         research spike rfc postmortem" >&2
echo "  Example:  feat(auth): add OAuth2 login" >&2
exit 2
