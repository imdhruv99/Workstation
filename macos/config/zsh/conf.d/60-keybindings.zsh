# 60-keybindings.zsh - emacs-style line editing + quality-of-life bindings.

bindkey -e   # emacs keymap (Ctrl-A/E/K/…); switch to `bindkey -v` for vi mode.

# History substring search on ↑/↓ using what's already typed.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search      # Up
bindkey '^[[B' down-line-or-beginning-search    # Down

# Word-wise navigation with Option+←/→ (macOS / Ghostty send these escapes).
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word

# Accept the autosuggestion with Ctrl-Space.
bindkey '^ ' autosuggest-accept

# Edit the current command line in $EDITOR with Ctrl-X Ctrl-E.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Delete key + Home/End (Ghostty defaults).
bindkey '^[[3~' delete-char
bindkey '^[[H'  beginning-of-line
bindkey '^[[F'  end-of-line
