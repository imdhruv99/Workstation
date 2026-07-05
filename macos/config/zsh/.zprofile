# $ZDOTDIR/.zprofile - login shells only. Heavy, run-once environment setup.
# Interactive niceties live in .zshrc; this file is for PATH/env that all
# login sessions (including non-interactive login shells) should inherit.

# --- Homebrew (Apple Silicon) -------------------------------------------------
# Sets PATH, MANPATH, INFOPATH and HOMEBREW_* for /opt/homebrew.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- Base user bin dirs -------------------------------------------------------
# Prepend personal bins so they win over system versions. Dedup happens in 20-path.zsh.
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
