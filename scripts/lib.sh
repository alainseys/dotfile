#!/usr/bin/env bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$REPO_ROOT/configs"

log() {
echo "[dotfiles] $*"
}

link_file() {
src="$1"
dst="$2"

mkdir -p "$(dirname "$dst")"


if [ -e "$dst" ] && [ ! -L "$dst" ]; then
log "Backing up $dst -> $dst.bak"
mv "$dst" "$dst.bak"
fi


ln -sf "$src" "$dst"
log "Linked $dst"
}