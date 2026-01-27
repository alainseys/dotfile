#!/usr/bin/env bash
set -e

source "$(dirname "$0")/lib.sh"

FILES=(
  ~/.zshrc
  ~/.gitconfig
  ~/.ssh/config
)

for f in "${FILES[@]}"; do
  if [ -f "$f" ]; then
    rel="${f#$HOME/}"
    dest="$CONFIG_DIR/$rel"

    mkdir -p "$(dirname "$dest")"
    cp "$f" "$dest"

    log "Imported $f"
    link_file "$dest" "$f"
  fi
done

log "Migration complete. Commit changes."