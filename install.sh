#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d-%H%M%S)"
RUN_BOOTSTRAP=true
BOOTSTRAP_ONLY=false

usage() {
  cat <<USAGE
Usage: ./install.sh [options]

Options:
  --no-bootstrap   Skip OS package bootstrap
  --bootstrap-only Run bootstrap only (no symlinks)
  -h, --help       Show help
USAGE
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
        esac
      fi
      echo "linux"
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

run_bootstrap() {
  local os="$1"
  local script=""

  case "$os" in
    macos) script="$DOTFILES_DIR/bootstrap/macos.sh" ;;
    debian) script="$DOTFILES_DIR/bootstrap/debian.sh" ;;
    arch) script="$DOTFILES_DIR/bootstrap/arch.sh" ;;
    *)
      echo "No bootstrap script for OS: $os"
      return
      ;;
  esac

  if [[ -x "$script" ]]; then
    echo "Running bootstrap: $script"
    "$script"
  else
    echo "Bootstrap script not executable: $script"
  fi
}

ensure_mise() {
  local os="$1"

  if command -v mise >/dev/null 2>&1; then
    echo "mise already installed"
    return
  fi

  case "$os" in
    macos)
      if command -v brew >/dev/null 2>&1; then
        brew install mise
      else
        echo "Homebrew not found; installing mise with official installer"
        curl https://mise.run | sh
      fi
      ;;
    debian|arch|linux)
      curl https://mise.run | sh
      ;;
    *)
      echo "Unsupported OS for automatic mise install: $os"
      return
      ;;
  esac

  export PATH="$HOME/.local/bin:$PATH"
  hash -r

  if ! command -v mise >/dev/null 2>&1; then
    echo "mise install appears to have failed"
    exit 1
  fi
}

install_mise_tools() {
  local config_file="$DOTFILES_DIR/mise/.config/mise/config.toml"

  if [[ ! -f "$config_file" ]]; then
    echo "No mise config found at $config_file; skipping tool installs"
    return
  fi

  echo "Installing tools via mise from $config_file"
  MISE_CONFIG_FILE="$config_file" mise install
}

link_file() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    local current
    current="$(readlink "$dst")"
    if [[ "$current" == "$src" ]]; then
      echo "already linked: $dst"
      return
    fi
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "${dst#$HOME/}")"
    mv "$dst" "$BACKUP_DIR/${dst#$HOME/}"
    echo "backed up: $dst -> $BACKUP_DIR/${dst#$HOME/}"
  fi

  ln -s "$src" "$dst"
  echo "linked: $dst -> $src"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-bootstrap)
      RUN_BOOTSTRAP=false
      ;;
    --bootstrap-only)
      BOOTSTRAP_ONLY=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
  shift
done

os="$(detect_os)"
echo "Detected OS: $os"

if [[ "$RUN_BOOTSTRAP" == true ]]; then
  run_bootstrap "$os"
  ensure_mise "$os"
  install_mise_tools
fi

if [[ "$BOOTSTRAP_ONLY" == true ]]; then
  echo "bootstrap-only mode complete"
  exit 0
fi

link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
link_file "$DOTFILES_DIR/zsh/.zsh_plugins.txt" "$HOME/.zsh_plugins.txt"
link_file "$DOTFILES_DIR/zsh/.config/zsh/zshrc_aliases" "$HOME/.config/zsh/zshrc_aliases"
link_file "$DOTFILES_DIR/mise/.config/mise/config.toml" "$HOME/.config/mise/config.toml"
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

echo "done"
