# 75-aliases-git.zsh - git productivity shortcuts (intuitive, conflict-free).

alias g='git'
alias gs='git status -sb'
alias gss='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'

alias gco='git checkout'
alias gcb='git checkout -b'
alias gsw='git switch'
alias gswc='git switch -c'

alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'

alias gd='git diff'          # delta-powered if configured in git
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all -30'

alias gp='git push'
alias gpf='git push --force-with-lease'   # safer than --force
alias gpu='git push -u origin HEAD'
alias gpl='git pull --rebase --autostash'
alias gf='git fetch --all --prune'

alias grb='git rebase'
alias grbi='git rebase -i'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'
alias grbm='git rebase origin/$(git_main_branch)'

alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias grh='git reset HEAD'
alias grhh='git reset --hard'   # destructive: intentional, not aliased to anything short

# Resolve the repo's main branch name (main vs master).
git_main_branch() {
  git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|origin/||' \
    || echo main
}

# Interactive branch switch via fzf.
gbf() {
  local branch
  branch=$(git branch --all | grep -v HEAD | sed 's/^[* ] //;s|remotes/origin/||' \
    | sort -u | fzf) && git switch "$(echo "$branch" | xargs)"
}
