#!/bin/bash

set -e 

echo "=========================================="
echo "  HYPRLAND INSTALLER (FEDORA)  "
echo "=========================================="

# 1.
echo "[1/4] Sytem update..."
sudo dnf update -y


sudo dnf groupinstall "Development Tools" "C Development Tools and Libraries" -y
sudo dnf install -y cmake meson ninja-build git wget curl

# 2.
echo "[2/4] Repositories enabled and Hyprland packets installation..."


sudo dnf copr enable erikreider/SwayOSD -y


PACKAGES=(
    "hyprland"
    "kitty"
    "waybar"
    "wofi"
    "dunst"
    "hyprpaper"
    "nautilus"
    "swayosd"
    "playerctl"
    "brightnessctl"
    "hyprshot"
    "grim"
    "slurp"
    "wl-clipboard"
    "polkit-gnome"
    "pamixer"
    "pavucontrol"
    "fontawesome-fonts"
    "fira-code-fonts"
    "google-noto-emoji-fonts"
)


sudo dnf install -y "${PACKAGES[@]}"

# 3. 
echo "[3/4] Config file copy..."

CONFIG_DIR="$HOME/.config"
SOURCE_DIR=$(pwd) 

DIRS_TO_COPY=("hypr" "waybar" "kitty" "wofi" "dunst")

mkdir -p "$CONFIG_DIR"

for dir in "${DIRS_TO_COPY[@]}"; do
    if [ -d "$SOURCE_DIR/$dir" ]; then
        
        if [ -d "$CONFIG_DIR/$dir" ]; then
            echo "  -> config already there $dir, backupping..."
            mv "$CONFIG_DIR/$dir" "$CONFIG_DIR/${dir}_backup_$(date +%Y%m%d_%H%M%S)"
        fi
        
        echo "  -> Copy of $dir in $CONFIG_DIR..."
        cp -r "$SOURCE_DIR/$dir" "$CONFIG_DIR/"
    else
        echo "  WARNING: directory $dir doesn't exists in repository, next."
    fi
done



# 4.
echo "[4/4] Cleaning + final setup..."
sudo dnf autoremove -y

echo "=========================================="
echo "  INSTALLAZIONE COMPLETATA!               "
echo "  Riavvia il sistema o fai logout.        "
echo "=========================================="
