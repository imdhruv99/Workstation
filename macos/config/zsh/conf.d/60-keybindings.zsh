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

# --- Overwrite prompt for `>` redirection -------------------------------------
# With NO_CLOBBER (see 00-options.zsh) a plain `>` to an existing file aborts
# with "zsh: file exists: <file>". This widget intercepts accept-line, detects
# truncating redirects to existing files, and asks before overwriting instead
# of erroring. Confirming lifts NO_CLOBBER for that one command only.
autoload -Uz add-zsh-hook

_clobber_reenable() {
  setopt no_clobber
  add-zsh-hook -d precmd _clobber_reenable
}

_clobber_confirm-accept-line() {
  emulate -L zsh
  local -a toks hits
  local i op fname
  toks=(${(z)BUFFER})
  for (( i = 1; i <= $#toks; i++ )); do
    op=$toks[i]
    # Truncating redirects only: `>`, `1>`, `2>`, `&>` — not `>>`, `>|`, `>&`.
    if [[ $op == (<->|'&'|)'>' ]]; then
      fname=${(Q)toks[i+1]}
      [[ -n $fname && -e $fname && ! -d $fname ]] && hits+=("$fname")
    fi
  done

  if (( $#hits )); then
    local reply
    print -rn -- $'\n'"file exists: ${(j:, :)hits} — overwrite? [y/N] "
    read -k 1 reply </dev/tty
    print -r -- ""
    if [[ $reply != [yY] ]]; then
      zle reset-prompt
      return
    fi
    unsetopt no_clobber
    add-zsh-hook precmd _clobber_reenable
  fi

  zle .accept-line
}
zle -N accept-line _clobber_confirm-accept-line
