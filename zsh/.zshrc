# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source antidote if installed
if [[ -f "$HOME/.antidote/antidote.zsh" ]]; then
  source "$HOME/.antidote/antidote.zsh"
  antidote load
else
  echo "antidote not found at ~/.antidote/antidote.zsh (plugins disabled)"
fi

if [[ -x "$HOME/.local/bin/mise" ]]; then
  eval "$(~/.local/bin/mise activate zsh)"
fi
source ~/.config/zsh/zshrc_aliases
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
