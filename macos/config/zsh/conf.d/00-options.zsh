# 00-options.zsh - shell behavior + safety guard rails.

# --- Directory navigation -----------------------------------------------------
setopt AUTO_CD              # `foo` == `cd foo` if foo is a dir
setopt AUTO_PUSHD           # cd pushes onto the dir stack
setopt PUSHD_IGNORE_DUPS    # no duplicate dirs on the stack
setopt PUSHD_SILENT         # don't print the stack on pushd/popd
setopt CDABLE_VARS          # `cd name` can resolve a named var to a path

# --- Globbing / expansion -----------------------------------------------------
setopt EXTENDED_GLOB        # #, ~, ^ glob operators
setopt NUMERIC_GLOB_SORT    # sort numbered files numerically
setopt NO_NOMATCH           # pass through globs that don't match (fewer surprises)

# --- Correction / completion feel --------------------------------------------
setopt INTERACTIVE_COMMENTS # allow `# comments` in interactive shell
setopt COMPLETE_IN_WORD     # complete from cursor position, not just word end
setopt ALWAYS_TO_END        # move cursor to end after completion
unsetopt FLOW_CONTROL       # free up Ctrl-S / Ctrl-Q for keybindings

# --- Safety guard rails -------------------------------------------------------
setopt NO_CLOBBER           # `>` won't overwrite existing files; use `>|` to force
setopt RM_STAR_WAIT         # 10s pause before `rm *` executes
unsetopt BEEP               # no terminal bell
