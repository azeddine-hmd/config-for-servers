#!/usr/bin/env bash
# Install dotfiles from azeddine-hmd/config-for-servers
# Usage: curl -fsSL https://raw.githubusercontent.com/azeddine-hmd/config-for-servers/main/install.sh | bash
set -euo pipefail
 
REPO_RAW="https://raw.githubusercontent.com/azeddine-hmd/config-for-servers/main"
FILES=(.bashrc .tmux.conf .vimrc)
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
 
command -v curl >/dev/null 2>&1 || { echo "Error: curl is required." >&2; exit 1; }
 
for f in "${FILES[@]}"; do
  tmp="$(mktemp)"
  if ! curl -fsSL "$REPO_RAW/$f" -o "$tmp"; then
    echo "✗ Failed to download $f" >&2
    rm -f "$tmp"
    continue
  fi
 
  if [ -e "$HOME/$f" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$HOME/$f" "$BACKUP_DIR/$f"
    echo "↺ Backed up existing $f to $BACKUP_DIR/"
  fi
 
  mv "$tmp" "$HOME/$f"
  echo "✓ Installed $f"
done
 
echo
echo "Done. Run 'source ~/.bashrc' or open a new shell to apply."
echo "If tmux is running: tmux source-file ~/.tmux.conf"
