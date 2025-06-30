#!/usr/bin/env bash
set -euo pipefail
if [[ -n "${1-}" ]]; then
  WALL_DIR="$1"
elif [[ -n "${HOME-}" ]]; then
  WALL_DIR="$HOME/.config/nixos/Wallpapers"
fi

IMG=$(find "$WALL_DIR" -maxdepth 1 -type f \
      \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \) \
      | shuf -n1)


echo "Меняем обои на: $IMG"
swww img --transition-fps=60 --transition-type=wipe --transition-angle=30 "$IMG"

