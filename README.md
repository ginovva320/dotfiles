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
- `bin/update`

## Install on a new machine

With curl:

```bash
curl -fsSL https://raw.githubusercontent.com/ginovva320/dotfiles/main/bootstrap/install.sh | bash
```

Pass installer flags after `bash -s --`:

```bash
curl -fsSL https://raw.githubusercontent.com/ginovva320/dotfiles/main/bootstrap/install.sh | bash -s -- --no-bootstrap
```

Or clone manually:

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
It attempts to set your login shell to `zsh` when available.

Language runtimes and extra CLI tools managed by `mise` are opt-in. To install
the tools from `mise/.config/mise/config.toml`, run:

```bash
./install.sh --install-tools
```

Git includes useful defaults and aliases, including:

- `git up` -> `git remote update -p; git merge --ff-only @{u}`
- `https://github.com/...` URLs automatically use SSH via `git@github.com:...`

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
./install.sh --install-tools
```

## Updating

Run `update` to pull dotfiles and refresh tools/packages:

```bash
update
```

## Notes

- Existing target files are backed up to `~/.dotfiles_backup/<timestamp>/`.
- This repo intentionally does **not** track secrets like SSH keys, cloud credentials, tokens, or shell history.
