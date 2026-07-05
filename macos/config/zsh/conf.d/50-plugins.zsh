# 50-plugins.zsh - interactive plugins. Order matters; syntax-highlighting is
# intentionally NOT here — it must load LAST (see 99-prompt.zsh) to wrap widgets.

_brew_prefix="$(command -v brew >/dev/null 2>&1 && brew --prefix)"

# --- zsh-autosuggestions (fish-style inline suggestions) ---------------------
_autosuggest="$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
if [[ -r "$_autosuggest" ]]; then
  source "$_autosuggest"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"          # dim grey suggestion
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20              # skip suggest on huge buffers
fi
unset _autosuggest

# --- zoxide (frecency-based directory jumping) -------------------------------
# `z foo` jumps, `zi` interactive pick. `cd` is unchanged.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# --- fzf (fuzzy finder key bindings + completion) ----------------------------
# Modern fzf ships shell integration via `fzf --zsh`.
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh) 2>/dev/null
fi

# --- atuin (SQLite history, better Ctrl-R) -----------------------------------
# --disable-up-arrow keeps native up-arrow line editing; Ctrl-R = atuin search.
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

unset _brew_prefix
