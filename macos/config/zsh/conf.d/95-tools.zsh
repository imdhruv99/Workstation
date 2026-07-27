# 95-tools.zsh - integrations for version managers and env tools.
# Slow initializers are lazy-loaded to protect startup time.

# --- direnv (per-directory env / .envrc) -------------------------------------
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# --- pyenv --------------------------------------------------------------------
# Add pyenv's shims to PATH eagerly. This is cheap (just a PATH prepend) and,
# crucially, must happen BEFORE any venv is activated: `source venv/bin/activate`
# prepends venv/bin AHEAD of the shims, so an active venv always wins.
#
# Do NOT wrap python/pip as lazy functions: a shell function shadows PATH, so
# the first `python` call inside a venv would trigger `pyenv init -`, which
# re-prepends the shims in front of the venv and breaks it until you
# deactivate/reactivate. Only the heavier interactive init stays lazy, behind
# the `pyenv` command itself (completions / virtualenv hooks).
if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
  path=("$PYENV_ROOT/bin" $path)
  _pyenv_path="$(pyenv init --path 2>/dev/null)"
  if [[ -n "$_pyenv_path" ]]; then
    eval "$_pyenv_path"                 # modern pyenv: prepends shims to PATH
  else
    path=("$PYENV_ROOT/shims" $path)    # fallback for very old pyenv
  fi
  unset _pyenv_path
  pyenv() {
    unfunction pyenv
    eval "$(pyenv init - zsh)"
    command -v pyenv-virtualenv-init >/dev/null 2>&1 && eval "$(pyenv virtualenv-init - zsh)"
    pyenv "$@"
  }
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
