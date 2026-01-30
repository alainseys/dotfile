#!/usr/bin/env bash
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT_DIR="$REPO_ROOT/scripts"
CONFIG_DIR="$REPO_ROOT/configs"
WATCHER="$SCRIPT_DIR/watch-configs.sh"
CONFIG_FILE="$REPO_ROOT/scripts/watch-configs.conf"
SERVICE_DIR="$HOME/.config/systemd/user"
SERVICE_FILE="$SERVICE_DIR/dotfiles-watcher.service"

log() {
  echo "[dotfiles] $*"
}

# Install inotify-tools if needed
log "Installing inotify-tools if needed"

if ! command -v inotifywait >/dev/null; then
  if command -v apt >/dev/null; then
    sudo apt update
    sudo apt install -y inotify-tools
  elif command -v dnf >/dev/null; then
    sudo dnf install -y inotify-tools
  else
    echo "Unsupported package manager"
    exit 1
  fi
fi

# Create default watcher config if missing
if [ ! -f "$CONFIG_FILE" ]; then
  log "Creating default watch-configs.conf"
  cat > "$CONFIG_FILE" <<'EOF'
# One path per line, supports environment variables
$HOME/.zshrc
$HOME/.gitconfig
$HOME/.ssh
EOF
fi

log "Creating watcher script"

cat > "$WATCHER" <<'EOF'
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
EOF

chmod +x "$WATCHER"

log "Creating systemd user service"

mkdir -p "$SERVICE_DIR"

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Dotfiles watcher

[Service]
ExecStart=$WATCHER
Restart=always

[Install]
WantedBy=default.target
EOF

log "Reloading systemd user daemon"
systemctl --user daemon-reload

log "Enabling service"
systemctl --user enable dotfiles-watcher.service

log "Starting service"
systemctl --user start dotfiles-watcher.service

log "Done."

echo
echo "Status:"
systemctl --user status dotfiles-watcher.service --no-pager
