#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${DOTFILES_REPO_URL:-https://github.com/ginovva320/dotfiles.git}"
BRANCH="${DOTFILES_BRANCH:-main}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

if ! command -v git >/dev/null 2>&1; then
  echo "git is required. Install git, then retry."
  exit 1
fi

if [[ -e "$DOTFILES_DIR" ]]; then
  echo "$DOTFILES_DIR already exists."
  echo "Move it aside or remove it, then retry:"
  echo "  rm -rf $DOTFILES_DIR"
  exit 1
fi

git clone --branch "$BRANCH" "$REPO_URL" "$DOTFILES_DIR"
exec "$DOTFILES_DIR/install.sh" "$@"
