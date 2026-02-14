# dotfiles

Personal shell/editor/git configuration managed in a small symlink-based repo.

## What's tracked

- `zsh/.zshrc`
- `zsh/.p10k.zsh`
- `zsh/.zsh_plugins.txt`
- `zsh/.config/zsh/zshrc_aliases`
- `mise/.config/mise/config.toml`
- `git/.gitconfig`
- `tmux/.tmux.conf`
- `vim/.vimrc`

## Install on a new machine

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

Then restart your shell:

```bash
exec zsh
```

## Bootstrap behavior

`install.sh` auto-detects OS and runs package bootstrap before linking files.
It also ensures `mise` is installed and runs `mise install` using your tracked config.

Git includes useful defaults and aliases, including:

- `git up` -> `git remote update -p; git merge --ff-only @{u}`

Supported bootstrap scripts:

- `bootstrap/macos.sh` (Homebrew)
- `bootstrap/debian.sh` (`apt`)
- `bootstrap/arch.sh` (`pacman`)

Package lists are in:

- `packages/macos.txt`
- `packages/common.txt`
- `packages/debian.txt`
- `packages/arch.txt`

Useful flags:

```bash
./install.sh --no-bootstrap
./install.sh --bootstrap-only
```

## Notes

- Existing target files are backed up to `~/.dotfiles_backup/<timestamp>/`.
- This repo intentionally does **not** track secrets like SSH keys, cloud credentials, tokens, or shell history.
