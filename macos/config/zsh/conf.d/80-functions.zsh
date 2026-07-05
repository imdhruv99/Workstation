# 80-functions.zsh - general-purpose functions (fast project search & nav).

# mkcd: make a directory (with parents) and cd into it.
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# extract: unpack most archive types by extension.
extract() {
  local f="$1"
  [[ -f "$f" ]] || { print -u2 "extract: '$f' is not a file"; return 1; }
  case "$f" in
    *.tar.bz2|*.tbz2) tar xjf "$f" ;;
    *.tar.gz|*.tgz)   tar xzf "$f" ;;
    *.tar.xz)         tar xJf "$f" ;;
    *.tar)            tar xf  "$f" ;;
    *.bz2)            bunzip2 "$f" ;;
    *.gz)             gunzip  "$f" ;;
    *.zip)            unzip   "$f" ;;
    *.rar)            unrar x "$f" ;;
    *.7z)             7z x    "$f" ;;
    *) print -u2 "extract: unknown archive type '$f'"; return 1 ;;
  esac
}

# ff: fuzzy-find a file and open it in $EDITOR.
ff() {
  local file
  file=$(fzf --preview 'bat --color=always --style=numbers {} 2>/dev/null || cat {}') \
    && ${EDITOR} "$file"
}

# fcd: fuzzy-find a directory (respects .gitignore) and cd into it.
fcd() {
  local dir
  dir=$(fd --type d --hidden --exclude .git 2>/dev/null | fzf) && cd "$dir"
}

# proj: jump to a project dir under common roots, fuzzy-picked.
proj() {
  local base dir
  for base in "$HOME/code" "$HOME/projects" "$HOME/work" "$HOME/src"; do
    [[ -d "$base" ]] && dir=$(fd --type d --max-depth 2 . "$base" 2>/dev/null)
    [[ -n "$dir" ]] && break
  done
  local pick
  pick=$(printf '%s\n' "$dir" | fzf) && cd "$pick"
}

# rgf: ripgrep + fzf to search content and open the match in $EDITOR at the line.
rgf() {
  local match file line
  match=$(rg --line-number --no-heading --color=always "${1:-}" \
            | fzf --ansi --delimiter : --preview 'bat --color=always {1} --highlight-line {2}') || return
  file=${match%%:*}; line=$(echo "$match" | cut -d: -f2)
  [[ -n "$file" ]] && ${EDITOR} +"$line" "$file"
}

# backup: timestamped copy of a file.
backup() { cp -a -- "$1" "$1.$(date +%Y%m%d-%H%M%S).bak"; }

# zsh-bench: measure interactive startup time (10 runs).
zsh-bench() {
  for _ in {1..10}; do /usr/bin/time zsh -i -c exit; done 2>&1 \
    | awk '{print $1" "$2}'
  print -- "Tip: for a per-line profile, uncomment zmodload/zprof in .zshrc."
}
