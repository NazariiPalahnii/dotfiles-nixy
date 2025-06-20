#!/usr/bin/env bash 

TARGET_DIR="/home/nixos/.config/nixos"

TERMINAL_CMD=()
if command -v kitty &> /dev/null; then 
  TERMINAL_CMD=(kitty yazi "$TARGET_DIR")

"${TERMINAL_CMD[@]}"
