# 10-exports.zsh - environment variables (no secrets here; use ~/.config/zsh/.secrets).

# --- Editors / pager ----------------------------------------------------------
export EDITOR="${EDITOR:-vim}"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-FRX"          # -F quit-if-one-screen, -R raw colors, -X no clear

# --- Locale -------------------------------------------------------------------
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# --- Tool config homes (keep $HOME clean) ------------------------------------
export DOCKER_CONFIG="${DOCKER_CONFIG:-$XDG_CONFIG_HOME/docker}"
export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

# --- bat as the man/colorizer backend ----------------------------------------
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export BAT_THEME="ansi"
fi

# --- fzf defaults: use fd, nice preview, sane layout -------------------------
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"

# --- Load machine-local secrets if present (git-ignored, never committed) -----
[[ -r "$ZDOTDIR/.secrets" ]] && source "$ZDOTDIR/.secrets"
