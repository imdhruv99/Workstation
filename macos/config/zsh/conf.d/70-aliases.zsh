# 70-aliases.zsh - general aliases. Each modern tool falls back gracefully.

# --- Listing (eza) ------------------------------------------------------------
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -lh --group-directories-first --icons=auto --git'
  alias la='eza -lah --group-directories-first --icons=auto --git'
  alias lt='eza --tree --level=2 --icons=auto'
  alias ltt='eza --tree --level=4 --icons=auto'
else
  alias ll='ls -lh'
  alias la='ls -lah'
fi

# --- cat / grep / find --------------------------------------------------------
command -v bat  >/dev/null 2>&1 && alias cat='bat --paging=never' && alias catp='bat'
command -v rg   >/dev/null 2>&1 && alias grep='rg'
command -v fd   >/dev/null 2>&1 && alias find='fd'
command -v procs>/dev/null 2>&1 && alias ps='procs'
command -v dust >/dev/null 2>&1 && alias du='dust'
command -v duf  >/dev/null 2>&1 && alias df='duf'
command -v btop >/dev/null 2>&1 && alias top='btop'

# --- Navigation ---------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias mkdir='mkdir -p'

# --- Safety (interactive confirm; NO_CLOBBER handles > already) ---------------
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# --- Reload / edit config -----------------------------------------------------
alias reload='exec zsh'
alias zshrc='$EDITOR "$ZDOTDIR/.zshrc"'
alias zconf='cd "$ZDOTDIR/conf.d"'

# --- Misc ---------------------------------------------------------------------
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias ip='curl -s ifconfig.me; echo'
alias please='sudo $(fc -ln -1)'   # re-run last command with sudo
