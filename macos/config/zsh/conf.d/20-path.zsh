# 20-path.zsh - PATH management with automatic de-duplication.

# `typeset -U path` keeps the array unique (drops duplicates, keeps first).
typeset -U path PATH

# Prepend in priority order (first = highest priority).
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "$XDG_DATA_HOME/../bin"       # ~/.local/bin alt spelling safety
  $path
)

# Common language/tool bins added only if the dir exists (avoids stale entries).
for _p in \
  "$HOME/.cargo/bin" \
  "$HOME/go/bin" \
  "/opt/homebrew/opt/curl/bin" ; do
  [[ -d "$_p" ]] && path=("$_p" $path)
done
unset _p

export PATH
