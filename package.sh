#!/usr/bin/env sh
# Packages the uncle-pop folder into uncle-pop.skill (a zip archive with uncle-pop/ at its root).
#
# Usage:
#   ./package.sh
set -eu

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT="$ROOT_DIR/uncle-pop.skill"

rm -f "$OUTPUT"
cd "$ROOT_DIR"
zip -qrX "$OUTPUT" uncle-pop -x '*.DS_Store'
echo "Packaged $OUTPUT"
