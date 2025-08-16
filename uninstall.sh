#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

services=(swww.service swaync.service cliphist.service mood-engine.service wallust.path scenes.timer scenes.service mpvpaper@.service)
for srv in "${services[@]}"; do
  systemctl --user disable --now "$srv" 2>/dev/null || true
done

if [[ -x $(command -v stow) ]]; then
  stow -d "$REPO_ROOT/stow" -t "$HOME" -D waybar wofi rofi swaync wezterm kitty gtk kvantum firefox starship zsh fish swaylock mime templates hypr niri 2>/dev/null || true
fi

if [[ -f /etc/arch-release ]]; then
  sudo sed -i 's/^Color/#Color/' /etc/pacman.conf
  sudo sed -i 's/^ParallelDownloads = 5/#ParallelDownloads = 5/' /etc/pacman.conf
fi

echo "Optional package removal skipped. Remove manually if desired."
echo "SkogsLjus uninstalled."
