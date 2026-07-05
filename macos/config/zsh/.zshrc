# $ZDOTDIR/.zshrc - interactive shell entry point.
# Responsibility: source every module in conf.d in deterministic (numeric) order.
# Add/remove features by adding/removing files in conf.d - no edits here needed.

# Guard: only run for interactive shells.
[[ -o interactive ]] || return

# Uncomment the next line + the `zprof` at the bottom to profile startup cost.
# zmodload zsh/zprof

# Source all modules in sorted order. `(N)` = null glob (no error if empty),
# `.` = plain files only. Each file is validated as readable before sourcing.
if [[ -d "${ZDOTDIR}/conf.d" ]]; then
  for _module in "${ZDOTDIR}"/conf.d/*.zsh(N.); do
    [[ -r "$_module" ]] && source "$_module"
  done
  unset _module
fi

# zprof   # <- uncomment together with zmodload above to see the startup profile
