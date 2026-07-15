# 95-tools.zsh - integrations for version managers and env tools.
# Slow initializers are lazy-loaded to protect startup time.

# --- direnv (per-directory env / .envrc) -------------------------------------
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# --- pyenv (lazy) -------------------------------------------------------------
# pyenv init is slow; defer it until first use of pyenv/python/pip.
if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
  path=("$PYENV_ROOT/bin" $path)
  _lazy_pyenv() {
    unalias pyenv python python3 pip pip3 2>/dev/null
    unfunction pyenv python python3 pip pip3 2>/dev/null
    eval "$(pyenv init - zsh)"
    command -v pyenv-virtualenv-init >/dev/null 2>&1 && eval "$(pyenv virtualenv-init - zsh)"
  }
  for _cmd in pyenv python python3 pip pip3; do
    # An existing alias (e.g. `pip` from 90-ml.zsh) blocks a same-name function,
    # so drop any alias before defining the lazy wrapper.
    unalias "$_cmd" 2>/dev/null
    eval "${_cmd}() { _lazy_pyenv; ${_cmd} \"\$@\"; }"
  done
  unset _cmd
fi

# --- jenv (Java, lazy) --------------------------------------------------------
if command -v jenv >/dev/null 2>&1; then
  path=("$HOME/.jenv/bin" $path)
  jenv() { unfunction jenv; eval "$(command jenv init -)"; jenv "$@"; }
fi

# --- fnm (Node.js / npm) ------------------------------------------------------
# fnm env is fast (Rust), so init directly. `--use-on-cd` auto-switches the
# Node version when you cd into a dir with a .nvmrc / .node-version file.
# Install a Node version to get `node`/`npm`:  fnm install --lts
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# --- tfenv (Terraform version manager) ---------------------------------------
# tfenv is a shim on PATH already via brew; nothing to init, kept for clarity.

# --- gcloud SDK ---------------------------------------------------------------
# Source the completion + path helpers if the SDK dir is present.
for _gc in \
  "/opt/homebrew/share/google-cloud-sdk/path.zsh.inc" \
  "$HOME/google-cloud-sdk/path.zsh.inc"; do
  [[ -r "$_gc" ]] && source "$_gc" && break
done
for _gc in \
  "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc" \
  "$HOME/google-cloud-sdk/completion.zsh.inc"; do
  [[ -r "$_gc" ]] && source "$_gc" && break
done
unset _gc
