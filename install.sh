#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

if [[ $(id -u) -eq 0 ]]; then
  echo "Run as regular user, not root" >&2
  exit 1
fi

if [[ ! -f /etc/arch-release ]]; then
  echo "Arch Linux required" >&2
  exit 1
fi

if lspci | grep -qi nvidia; then
  echo "NVIDIA hardware detected. SkogsLjus supports AMD only." >&2
  exit 1
fi

if ! command -v sudo >/dev/null; then
  echo "sudo is required" >&2
  exit 1
fi

# pacman tweaks
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf

PACKAGES=(
  "base-devel" "git" "stow" "gnu-free-fonts" "xdg-user-dirs" \
  "waybar" "wofi" "rofi-wayland" "swaync" "swaylock" \
  "wallust" "pywal" "swww" "mpv" "mpvpaper" \
  "wezterm" "kitty" "thunar" "grim" "slurp" "swappy" \
  "wf-recorder" "cliphist" "cava" "jq" "imagemagick" "sox" "aubio" \
  "bluez" "bluez-utils" "lm_sensors" "kvantum" "qt5ct" "qt6ct" \
  "papirus-icon-theme" "papirus-folders" "btop" "fastfetch" "yazi" \
  "playerctl" "wireplumber" "xdg-desktop-portal-gtk" "sdl2" "gum" \
  "hyprcursor" "hyprpaper" "xdg-desktop-portal-hyprland" \
  "xdg-desktop-portal-wlr" "swayimg" "curl" "inkscape" \
  "networkmanager" "yq" "gettext"
)

# install yay if not present
if ! command -v yay >/dev/null; then
  sudo pacman -S --needed --noconfirm base-devel git stow
  git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
  pushd /tmp/yay-bin >/dev/null
  makepkg -si --noconfirm
  popd >/dev/null
fi

yay -S --needed --noconfirm "${PACKAGES[@]}"

CHOICE="Hyprland"
if command -v gum >/dev/null; then
  CHOICE=$(gum choose Hyprland Niri || echo Hyprland)
else
  if command -v whiptail >/dev/null; then
    CHOICE=$(whiptail --title "Choose compositor" --menu "" 10 40 2 Hyprland Hyprland Niri Niri 3>&2 2>&1 1>&3)
  fi
fi

mkdir -p "$HOME/.config"

# dotfiles via stow
stow -d "$REPO_ROOT/stow" -t "$HOME" \
  waybar wofi rofi swaync wezterm kitty gtk kvantum firefox starship zsh fish swaylock mime templates
if [[ $CHOICE == "Hyprland" ]]; then
  stow -d "$REPO_ROOT/stow" -t "$HOME" hypr
else
  stow -d "$REPO_ROOT/stow" -t "$HOME" niri
fi

# services
mkdir -p "$HOME/.config/systemd/user"
cp systemd/user/mood-engine.service systemd/user/mood-engine.timer systemd/user/swww.service "$HOME/.config/systemd/user/"
systemctl --user enable --now swww.service swaync.service cliphist.service wallust.path mood-engine.timer
systemctl --user enable --now xdg-desktop-portal-hyprland.service 2>/dev/null || true
systemctl --user enable --now xdg-desktop-portal-wlr.service 2>/dev/null || true

# wallpaper setup
scripts/prerender-wallpaper
scripts/mood-engine
scripts/theme-apply

scripts/build-cursor
scripts/first-run-wizard

echo "Install complete. Reboot recommended." 
