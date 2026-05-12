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
  "polkit-gnome"
  "pamixer"
  "pavucontrol"
  "fontawesome-fonts"
  "fira-code-fonts"
  "google-noto-emoji-fonts"
)

sudo dnf install -y "${PACKAGES[@]}"

# 3.
echo "[3/4] Creazione Link Simbolici (Dotfiles)..."

CONFIG_DIR="$HOME/.config"
# Ottiene il percorso assoluto della cartella dove si trova lo script
SOURCE_DIR=$(pwd)

DIRS_TO_LINK=("hypr" "waybar" "kitty" "wofi" "dunst")

mkdir -p "$CONFIG_DIR"

for dir in "${DIRS_TO_LINK[@]}"; do
    if [ -d "$SOURCE_DIR/$dir" ]; then
        
        # Se esiste già una cartella reale (non un link), facciamo il backup
        if [ -d "$CONFIG_DIR/$dir" ] && [ ! -L "$CONFIG_DIR/$dir" ]; then
            echo "  -> Cartella reale trovata per $dir, eseguo backup..."
            mv "$CONFIG_DIR/$dir" "$CONFIG_DIR/${dir}_backup_$(date +%Y%m%d_%H%M%S)"
        elif [ -L "$CONFIG_DIR/$dir" ]; then
            echo "  -> Link esistente per $dir rimosso per aggiornamento..."
            rm "$CONFIG_DIR/$dir"
        fi

        echo "  -> Creazione link: $CONFIG_DIR/$dir ---> $SOURCE_DIR/$dir"
        # ln -s crea il link simbolico
        ln -s "$SOURCE_DIR/$dir" "$CONFIG_DIR/$dir"
    else
        echo "  ATTENZIONE: La cartella $dir non esiste nella repo, salto."
    fi
done

# 4.
echo "[4/4] Cleaning + final setup..."
sudo dnf autoremove -y

echo "=========================================="
echo "  INSTALLAZIONE COMPLETATA!               "
echo "  Riavvia il sistema o fai logout.        "
echo "=========================================="
