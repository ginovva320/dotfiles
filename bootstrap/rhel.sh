#!/usr/bin/env bash
set -euo pipefail

if command -v dnf >/dev/null 2>&1; then
  pkg_manager=(sudo dnf install -y)
elif command -v yum >/dev/null 2>&1; then
  pkg_manager=(sudo yum install -y)
else
  echo "dnf/yum not found; skipping RHEL-family bootstrap"
  exit 0
fi

core_packages=(
  git
  zsh
  vim
  tmux
  wget
  unzip
  gcc
  gcc-c++
  make
)

optional_packages=(
  ripgrep
  fd-find
  bat
)

"${pkg_manager[@]}" "${core_packages[@]}"

for pkg in "${optional_packages[@]}"; do
  if ! "${pkg_manager[@]}" "$pkg"; then
    echo "optional package unavailable, skipping: $pkg"
  fi
done
