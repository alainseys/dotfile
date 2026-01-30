#!/usr/bin/env bash
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_DIR="$REPO_ROOT/configs"
CONFIG_FILE="$REPO_ROOT/scripts/watch-configs.conf"

log() {
  echo "[dotfiles] $*"
}

# Read WATCH_PATHS from config file
WATCH_PATHS=()
while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" || "$line" =~ ^# ]] && continue
  WATCH_PATHS+=("$(eval echo "$line")")
done < "$CONFIG_FILE"

if [ ${#WATCH_PATHS[@]} -eq 0 ]; then
  log "No paths to watch. Please add them to $CONFIG_FILE"
  exit 1
fi

cd "$REPO_ROOT"

log "Starting dotfiles watcher..."
if ! command -v inotifywait >/dev/null; then
  echo "inotifywait not found. Please install inotify-tools."
  exit 1
fi

while inotifywait -r -e close_write,create,move "${WATCH_PATHS[@]}"; do
  log "Change detected"

  for path in "${WATCH_PATHS[@]}"; do
    if [ -f "$path" ]; then
      rel="${path#$HOME/}"
      dest="$CONFIG_DIR/$rel"

      mkdir -p "$(dirname "$dest")"
      cp "$path" "$dest"

      git add "$dest"
      log "Synced $rel"
    fi
  done

  if ! git diff --cached --quiet; then
    git commit -m "Auto update dotfiles $(date '+%Y-%m-%d %H:%M:%S')"
    log "Committed changes"
  fi
done
