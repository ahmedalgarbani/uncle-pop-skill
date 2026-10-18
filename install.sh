#!/usr/bin/env sh
# Installs the uncle-pop skill by copying it into an agent's skills directory.
#
# Usage:
#   ./install.sh claude            -> ~/.claude/skills/uncle-pop          (Claude Code, personal)
#   ./install.sh claude-project    -> ./.claude/skills/uncle-pop          (Claude Code, this project)
#   ./install.sh antigravity       -> ./.agent/skills/uncle-pop           (Antigravity, this workspace)
#   ./install.sh <custom-dir>      -> <custom-dir>/uncle-pop
set -eu

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)/uncle-pop"

case "${1:-}" in
  claude)         TARGET_ROOT="$HOME/.claude/skills" ;;
  claude-project) TARGET_ROOT="$(pwd)/.claude/skills" ;;
  antigravity)    TARGET_ROOT="$(pwd)/.agent/skills" ;;
  "")             echo "Usage: $0 {claude|claude-project|antigravity|<skills-dir>}" >&2; exit 1 ;;
  *)              TARGET_ROOT="$1" ;;
esac

mkdir -p "$TARGET_ROOT"
rm -rf "$TARGET_ROOT/uncle-pop"
cp -R "$SOURCE_DIR" "$TARGET_ROOT/uncle-pop"
echo "uncle-pop installed to $TARGET_ROOT/uncle-pop"
