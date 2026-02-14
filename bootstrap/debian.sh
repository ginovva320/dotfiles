#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMMON_PACKAGES="$DOTFILES_DIR/packages/common.txt"
DEBIAN_PACKAGES="$DOTFILES_DIR/packages/debian.txt"

if ! command -v apt-get >/dev/null 2>&1; then
  echo "apt-get not found; skipping Debian bootstrap"
  exit 0
fi

packages=()
while IFS= read -r pkg; do
  packages+=("$pkg")
done < <(grep -hvE '^[[:space:]]*(#|$)' "$COMMON_PACKAGES" "$DEBIAN_PACKAGES" | sed 's/^fd-find$/fd-find/' | sort -u)

if [[ ${#packages[@]} -eq 0 ]]; then
  echo "No packages to install for Debian/Ubuntu"
  exit 0
fi

sudo apt-get update
sudo apt-get install -y "${packages[@]}"
