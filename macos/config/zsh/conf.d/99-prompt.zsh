# 99-prompt.zsh - prompt + syntax highlighting. MUST be sourced LAST.

# --- Starship prompt ----------------------------------------------------------
if command -v starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"
  eval "$(starship init zsh)"
fi

# --- zsh-syntax-highlighting (LAST so it can wrap all defined widgets) --------
# Prefer fast-syntax-highlighting if installed, else zsh-syntax-highlighting.
_brew_prefix="$(command -v brew >/dev/null 2>&1 && brew --prefix)"
for _hl in \
  "$_brew_prefix/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" \
  "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"; do
  if [[ -r "$_hl" ]]; then source "$_hl"; break; fi
done
unset _hl _brew_prefix
