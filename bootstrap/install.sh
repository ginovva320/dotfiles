#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${DOTFILES_REPO_URL:-https://github.com/ginovva320/dotfiles.git}"
BRANCH="${DOTFILES_BRANCH:-main}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
GIT_CONFIG_HOME="${TMPDIR:-/tmp}/dotfiles-bootstrap-git-config"

git_bootstrap() {
  mkdir -p "$GIT_CONFIG_HOME"
  GIT_CONFIG_NOSYSTEM=1 \
    GIT_CONFIG_SYSTEM=/dev/null \
    GIT_CONFIG_GLOBAL=/dev/null \
    XDG_CONFIG_HOME="$GIT_CONFIG_HOME" \
    git -c url.git@github.com:.insteadOf= \
      -c url.ssh://git@github.com/.insteadOf= \
      "$@"
}

detect_os() {
  case "$(uname -s)" in
    Darwin)
      echo "macos"
      ;;
    Linux)
      if [[ -r /etc/os-release ]]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        case "${ID:-}" in
          ubuntu|debian)
            echo "debian"
            return
            ;;
          arch)
            echo "arch"
            return
            ;;
          amzn|fedora|rhel|centos|rocky|almalinux)
            echo "rhel"
            return
            ;;
        esac
      fi
      echo "linux"
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

ensure_git() {
  if command -v git >/dev/null 2>&1; then
    return
  fi

  case "$(detect_os)" in
    debian)
      sudo apt-get update
      sudo apt-get install -y git
      ;;
    arch)
      sudo pacman -Sy --noconfirm --needed git
      ;;
    rhel)
      if command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y git
      elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y git
      else
        echo "dnf/yum not found; install git, then retry."
        exit 1
      fi
      ;;
    macos)
      echo "git is required. Install Xcode Command Line Tools or Homebrew git, then retry."
      exit 1
      ;;
    *)
      echo "git is required. Install git, then retry."
      exit 1
      ;;
  esac
}

checkout_dotfiles() {
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    git_bootstrap -C "$DOTFILES_DIR" remote set-url origin "$REPO_URL"
    git_bootstrap -C "$DOTFILES_DIR" fetch "$REPO_URL" "$BRANCH"
    git_bootstrap -C "$DOTFILES_DIR" checkout -B "$BRANCH" FETCH_HEAD
    return
  fi

  if [[ -e "$DOTFILES_DIR" ]]; then
    echo "$DOTFILES_DIR already exists but is not a git checkout."
    echo "Move it aside or set DOTFILES_DIR to a different path, then retry."
    exit 1
  fi

  git_bootstrap clone --branch "$BRANCH" "$REPO_URL" "$DOTFILES_DIR"
}

ensure_git
checkout_dotfiles
exec "$DOTFILES_DIR/install.sh" "$@"
