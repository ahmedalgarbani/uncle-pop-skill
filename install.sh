#!/usr/bin/env sh
# Installs the uncle-pop skill by copying it into an agent's skills directory.
#
# Usage:
#   ./install.sh claude                          -> ~/.claude/skills/uncle-pop                (Claude Code, personal)
#   ./install.sh claude-project [project-dir]    -> <project-dir>/.claude/skills/uncle-pop    (Claude Code, one project)
#   ./install.sh antigravity    [project-dir]    -> <project-dir>/.agent/skills/uncle-pop     (Antigravity, one workspace)
#   ./install.sh <custom-dir>                    -> <custom-dir>/uncle-pop
#
# <project-dir> defaults to the current directory. When you run the script from inside
# this repository (e.g. a clone placed in your project), it defaults to the parent folder,
# because installing the skill into its own repository is never what you want.
set -eu

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$REPO_DIR/uncle-pop"

resolve_project_dir() {
  if [ -n "${1:-}" ]; then
    mkdir -p "$1"
    (cd "$1" && pwd)
  elif [ "$(pwd)" = "$REPO_DIR" ]; then
    (cd "$REPO_DIR/.." && pwd)
  else
    pwd
  fi
}

case "${1:-}" in
  claude)         TARGET_ROOT="$HOME/.claude/skills" ;;
  claude-project) TARGET_ROOT="$(resolve_project_dir "${2:-}")/.claude/skills" ;;
  antigravity)    TARGET_ROOT="$(resolve_project_dir "${2:-}")/.agent/skills" ;;
  "")             echo "Usage: $0 {claude|claude-project [project-dir]|antigravity [project-dir]|<skills-dir>}" >&2; exit 1 ;;
  *)              TARGET_ROOT="$1" ;;
esac

mkdir -p "$TARGET_ROOT"
rm -rf "$TARGET_ROOT/uncle-pop"
cp -R "$SOURCE_DIR" "$TARGET_ROOT/uncle-pop"
echo "uncle-pop installed to $TARGET_ROOT/uncle-pop"
