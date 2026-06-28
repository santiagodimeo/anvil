#!/usr/bin/env bash
set -euo pipefail

# anvil build/install — expand <!-- @include path --> directives and install
# the result into ~/.claude (or $CLAUDE_CONFIG_DIR). This repo is the single
# source of truth; the installed files are generated — never edit them by hand.

ANVIL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

# Recursively expand include directives. Paths are relative to ANVIL_DIR.
# Usage: expand_includes <file> [depth]
expand_includes() {
  local file="$1" depth="${2:-0}" line inc incpath
  if [ "$depth" -gt 10 ]; then
    echo "error: @include nesting too deep at $file" >&2
    exit 1
  fi
  while IFS= read -r line || [ -n "$line" ]; do
    if printf '%s' "$line" | grep -qE '^[[:space:]]*<!--[[:space:]]*@include[[:space:]]'; then
      inc=$(printf '%s' "$line" | sed -E 's/^[[:space:]]*<!--[[:space:]]*@include[[:space:]]+([^[:space:]]+)[[:space:]]*-->[[:space:]]*$/\1/')
      incpath="$ANVIL_DIR/$inc"
      if [ ! -f "$incpath" ]; then
        echo "error: @include target not found: $inc (referenced in $file)" >&2
        exit 1
      fi
      expand_includes "$incpath" $((depth + 1))
    else
      printf '%s\n' "$line"
    fi
  done < "$file"
}

mkdir -p "$CLAUDE_DIR/commands" "$CLAUDE_DIR/skills" "$CLAUDE_DIR/hooks"

# Commands → ~/.claude/commands/ (includes expanded)
for f in "$ANVIL_DIR"/commands/*.md; do
  [ -e "$f" ] || continue
  expand_includes "$f" > "$CLAUDE_DIR/commands/$(basename "$f")"
done

# Skills → ~/.claude/skills/<name>/ (SKILL.md expanded, bundled assets copied)
for d in "$ANVIL_DIR"/skills/*/; do
  [ -e "$d" ] || continue
  name="$(basename "$d")"
  mkdir -p "$CLAUDE_DIR/skills/$name"
  expand_includes "${d}SKILL.md" > "$CLAUDE_DIR/skills/$name/SKILL.md"
  for asset in "$d"*; do
    case "$asset" in
      *"/SKILL.md") ;;
      *) [ -e "$asset" ] && cp -R "$asset" "$CLAUDE_DIR/skills/$name/" ;;
    esac
  done
done

# Hooks → ~/.claude/hooks/ (executable)
cp "$ANVIL_DIR"/hooks/*.sh "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR"/hooks/*.sh

# Global rules → the anvil-managed block of ~/.claude/CLAUDE.md
TARGET="$CLAUDE_DIR/CLAUDE.md"
BEGIN="<!-- anvil:begin (managed — edit anvil/CLAUDE.global.md) -->"
END="<!-- anvil:end -->"
touch "$TARGET"
tmp="$(mktemp)"
# Drop any existing managed block, preserving the user's own content.
awk -v b="$BEGIN" -v e="$END" '
  $0==b {skip=1; next}
  skip && $0==e {skip=0; next}
  !skip {print}
' "$TARGET" > "$tmp"
{
  cat "$tmp"
  printf '\n%s\n' "$BEGIN"
  cat "$ANVIL_DIR/CLAUDE.global.md"
  printf '%s\n' "$END"
} > "$TARGET"
rm -f "$tmp"

echo "anvil installed into $CLAUDE_DIR"
echo "  commands: $(ls "$ANVIL_DIR"/commands/*.md | wc -l | tr -d ' ')"
echo "  skills:   $(ls -d "$ANVIL_DIR"/skills/*/ 2>/dev/null | wc -l | tr -d ' ')"
echo "  hooks:    $(ls "$ANVIL_DIR"/hooks/*.sh | wc -l | tr -d ' ')"
echo "Note: settings.json is not touched — copy settings/settings.json.example and fill in credentials."
