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
  util-linux-user
  gnupg2
)

"${pkg_manager[@]}" "${core_packages[@]}"
