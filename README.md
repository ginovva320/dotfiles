# dotfiles

Personal shell/editor/git configuration managed in a small symlink-based repo.

## What's tracked

- `zsh/.zshrc`
- `zsh/.p10k.zsh`
- `zsh/.zsh_plugins.txt`
- `zsh/.config/zsh/zshrc_aliases`
- `git/.gitconfig`

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

## Notes

- Existing target files are backed up to `~/.dotfiles_backup/<timestamp>/`.
- This repo intentionally does **not** track secrets like SSH keys, cloud credentials, tokens, or shell history.
