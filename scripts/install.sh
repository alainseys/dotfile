#!/usr/bin/env bash
set -e

source "$(dirname "$0")/lib.sh"

log "Installing base packages"

if command -v apt >/dev/null; then
  sudo apt update
  sudo apt install -y zsh git curl
elif command -v dnf >/dev/null; then
  sudo dnf install -y zsh git curl
fi

log "Setting Zsh as default shell"
chsh -s "$(which zsh)"

log "Linking configs"

find "$CONFIG_DIR" -type f | while read -r file; do
  rel="${file#$CONFIG_DIR/}"
  link_file "$file" "$HOME/$rel"
done

log "Done. Log out/in to activate Zsh."