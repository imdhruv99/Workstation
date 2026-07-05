# 30-history.zsh - smart, deduplicated, shared history.
# NOTE: atuin (loaded in 50-plugins.zsh) takes over Ctrl-R search, but this
# native history is still the source of truth and a fallback.

export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=100000          # in-memory events
export SAVEHIST=100000          # events persisted to $HISTFILE
mkdir -p "${HISTFILE:h}"        # ensure the dir exists (:h = dirname)

setopt EXTENDED_HISTORY         # record timestamp + duration
setopt SHARE_HISTORY            # live-share history across open shells
setopt INC_APPEND_HISTORY       # append as commands run, not at exit
setopt HIST_IGNORE_DUPS         # skip consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS     # drop older duplicate of a re-run command
setopt HIST_IGNORE_SPACE        # ` cmd` (leading space) stays out of history
setopt HIST_FIND_NO_DUPS        # no dupes while searching
setopt HIST_REDUCE_BLANKS       # trim superfluous whitespace
setopt HIST_VERIFY              # expand `!!` etc. into the line before running
