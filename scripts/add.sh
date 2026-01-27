#!/usr/bin/env bash
set -e

source "$(dirname "$0")/lib.sh"

if [ -z "$1" ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

SRC="$(realpath "$1")"

if [[ "$SRC" != "$HOME"* ]]; then
  echo "Only files inside \$HOME supported"
  exit 1
fi

REL="${SRC#$HOME/}"
DEST="$CONFIG_DIR/$REL"

mkdir -p "$(dirname "$DEST")"
cp "$SRC" "$DEST"

log "Added $REL to repo"
link_file "$DEST" "$SRC"

log "Now git add configs/$REL"