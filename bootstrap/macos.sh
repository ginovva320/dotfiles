#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MACOS_PACKAGES="$DOTFILES_DIR/packages/macos.txt"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install from https://brew.sh first."
  exit 1
fi

mapfile -t packages < <(grep -vE '^[[:space:]]*(#|$)' "$MACOS_PACKAGES")

if [[ ${#packages[@]} -eq 0 ]]; then
  echo "No packages to install for macOS"
  exit 0
fi

brew update
brew install "${packages[@]}"
