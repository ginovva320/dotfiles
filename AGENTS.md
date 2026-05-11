# AGENTS.md

## Project

This repository contains personal dotfiles and small bootstrap scripts. Keep
changes conservative: prefer simple shell, symlinks, and package lists over new
frameworks or tooling.

## Layout

- `install.sh` is the main installer.
- `bootstrap/install.sh` is the curl-friendly entrypoint that clones or updates
  this repo and then delegates to `install.sh`.
- `bootstrap/{macos,debian,arch,rhel}.sh` install OS packages.
- `packages/*.txt` are package-manager input lists.
- `zsh/`, `git/`, `tmux/`, `vim/`, `mise/`, and `bin/` contain files linked
  into `$HOME`.

## Installer Behavior

- Default `./install.sh` runs OS bootstrap, installs Antidote, attempts to set
  the login shell to zsh, and links tracked config files.
- Mise language/runtime installs are intentionally opt-in. Do not make
  `mise install` run by default; use `--install-tools` / `--with-mise-tools`.
- Existing target files are backed up under `~/.dotfiles_backup/<timestamp>/`.
- Be careful with `git/.gitconfig`: it contains personal identity and rewrites
  GitHub HTTPS URLs to SSH.

## Editing Guidelines

- Use POSIX-ish Bash where practical, but keep the existing Bash style.
- Keep scripts idempotent and safe to rerun.
- Avoid destructive commands unless the user explicitly asks.
- Do not add secrets, tokens, keys, host-specific credentials, shell history, or
  machine-local state.
- When changing installer behavior, update `README.md` and run `bash -n` on any
  touched shell scripts.

## Verification

Run focused checks after edits:

```bash
bash -n install.sh
bash -n bootstrap/install.sh
```
