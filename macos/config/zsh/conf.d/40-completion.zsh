# 40-completion.zsh - completion engine, cached for fish-like startup speed.

# Homebrew completion functions on fpath (must be set before compinit).
if command -v brew >/dev/null 2>&1; then
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

autoload -Uz compinit

# Cache dir for the compdump; rebuild at most once per day, else load fast (-C).
_zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
mkdir -p "${_zcompdump:h}"

# Rebuild dump only if older than 24h; otherwise trust the cache (skip security scan).
if [[ -n "$_zcompdump"(#qN.mh+24) ]]; then
  compinit -d "$_zcompdump"
  # Compile the dump to bytecode so the next shell loads it faster.
  { [[ ! -s "${_zcompdump}.zwc" || "$_zcompdump" -nt "${_zcompdump}.zwc" ]] \
      && zcompile -R "$_zcompdump" } &!
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

# --- Completion styling -------------------------------------------------------
zstyle ':completion:*' menu select                       # arrow-key menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # colorize matches
zstyle ':completion:*' group-name ''                     # group by category
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' special-dirs true                 # complete ./ ../
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
