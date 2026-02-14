#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMMON_PACKAGES="$DOTFILES_DIR/packages/common.txt"
ARCH_PACKAGES="$DOTFILES_DIR/packages/arch.txt"

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman not found; skipping Arch bootstrap"
  exit 0
fi

mapfile -t packages < <(grep -hvE '^[[:space:]]*(#|$)' "$COMMON_PACKAGES" "$ARCH_PACKAGES" | sed 's/^fd-find$/fd/' | sed 's/^build-essential$/base-devel/' | sort -u)

if [[ ${#packages[@]} -eq 0 ]]; then
  echo "No packages to install for Arch"
  exit 0
fi

sudo pacman -Syu --noconfirm --needed "${packages[@]}"
