# 90-ml.zsh - Python env, uv, Jupyter, and ML workflow helpers.

# ============================== Python / venv ================================
alias py='python3'
alias pip='python3 -m pip'
alias venv='python3 -m venv .venv'          # create a venv in ./.venv
alias va='source .venv/bin/activate'        # activate local venv
alias da='deactivate 2>/dev/null'           # deactivate current venv

# mkvenv: create + activate a venv and upgrade pip in one shot.
mkvenv() {
  python3 -m venv "${1:-.venv}" && source "${1:-.venv}/bin/activate" \
    && python -m pip install --upgrade pip
}

# autovenv: auto-activate ./.venv when you cd into a project that has one.
# (Lightweight; direnv in 95-tools.zsh is the more powerful option.)
autovenv() {
  if [[ -f .venv/bin/activate ]]; then
    [[ "$VIRTUAL_ENV" != "$PWD/.venv" ]] && source .venv/bin/activate
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd autovenv

# ============================== uv (fast pip/venv) ===========================
if command -v uv >/dev/null 2>&1; then
  alias uvs='uv sync'                       # sync deps from lockfile
  alias uvr='uv run'                        # run a command in the project env
  alias uva='uv add'                        # add a dependency
  alias uvrm='uv remove'                    # remove a dependency
  alias uvpip='uv pip'                      # uv's pip-compatible interface
  alias uvx='uv tool run'                   # run a tool ephemerally
fi

# ============================== Jupyter ======================================
alias jl='jupyter lab'
alias jn='jupyter notebook'
# jlp: launch JupyterLab on a chosen port, no browser (good over SSH tunnels).
jlp() { jupyter lab --no-browser --port="${1:-8888}"; }
# nbclean: strip output from a notebook (needs nbstripout or jq fallback).
nbclean() {
  if command -v nbstripout >/dev/null 2>&1; then nbstripout "$@";
  else print -u2 "install nbstripout: uv tool install nbstripout"; return 1; fi
}

# ============================== GPU / training ===============================
# gpu: quick GPU status if nvidia-smi exists (remote boxes); noop locally on Mac.
alias gpu='command -v nvidia-smi >/dev/null && nvidia-smi || echo "no nvidia-smi (Apple Silicon uses MPS)"'
# watchgpu: live GPU utilization.
watchgpu() { command -v nvidia-smi >/dev/null && watch -n1 nvidia-smi; }

# pyclean: remove Python caches recursively in the current tree.
pyclean() {
  fd -H -t d '__pycache__' -x rm -rf {} 2>/dev/null
  fd -H -e pyc -x rm -f {} 2>/dev/null
  print "cleaned __pycache__ and .pyc under $PWD"
}
