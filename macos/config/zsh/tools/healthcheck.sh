#!/usr/bin/env bash
# healthcheck.sh - verifies the Ghostty + zsh setup. Non-destructive, read-only.
# Usage: bash ~/.config/zsh/tools/healthcheck.sh
set -uo pipefail

pass=0; fail=0; warn=0
ok()   { printf '\033[1;32m[✓]\033[0m %s\n' "$*"; pass=$((pass+1)); }
bad()  { printf '\033[1;31m[x]\033[0m %s\n' "$*"; fail=$((fail+1)); }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; warn=$((warn+1)); }
hdr()  { printf '\n\033[1;34m== %s ==\033[0m\n' "$*"; }

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

hdr "Core files"
for f in \
  "$HOME/.zshenv" \
  "$CONFIG/zsh/.zshrc" \
  "$CONFIG/zsh/.zprofile" \
  "$CONFIG/ghostty/config" \
  "$CONFIG/starship.toml"; do
  [[ -r "$f" ]] && ok "exists: $f" || bad "missing: $f"
done

hdr "conf.d modules"
count=$(ls "$CONFIG"/zsh/conf.d/*.zsh 2>/dev/null | wc -l | tr -d ' ')
[[ "$count" -ge 1 ]] && ok "$count modules found in conf.d" || bad "no modules in conf.d"

hdr "ZDOTDIR wiring"
grep -q 'ZDOTDIR' "$HOME/.zshenv" 2>/dev/null && ok "~/.zshenv sets ZDOTDIR" || bad "~/.zshenv missing ZDOTDIR"

hdr "Required tools"
for t in starship eza bat fd rg fzf zoxide delta gh jq yq atuin direnv uv pipx kubectx k9s stern; do
  command -v "$t" >/dev/null 2>&1 && ok "found: $t" || bad "missing: $t"
done

hdr "Optional tools"
for t in btop procs dust duf tldr; do
  command -v "$t" >/dev/null 2>&1 && ok "found: $t" || warn "optional missing: $t"
done

hdr "Existing integrations"
for t in git pyenv jenv tfenv kubectl gcloud; do
  command -v "$t" >/dev/null 2>&1 && ok "found: $t" || warn "not found: $t"
done

hdr "Plugin sources"
bp="$(brew --prefix 2>/dev/null)"
for p in \
  "$bp/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "$bp/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"; do
  [[ -r "$p" ]] && ok "readable: ${p##*/}" || warn "not found: $p"
done

hdr "Nerd Font"
if ls ~/Library/Fonts/JetBrainsMono*Nerd* >/dev/null 2>&1 \
   || fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd"; then
  ok "JetBrainsMono Nerd Font present"
else
  warn "JetBrainsMono Nerd Font not detected (glyphs may be missing)"
fi

hdr "Startup benchmark (3 runs)"
if command -v zsh >/dev/null 2>&1; then
  for i in 1 2 3; do
    /usr/bin/time zsh -i -c exit 2>&1 | awk '{printf "  run '"$i"': %s %s\n",$1,$2}'
  done
fi

hdr "Git delta"
[[ "$(git config --global core.pager 2>/dev/null)" == "delta" ]] \
  && ok "git uses delta" || warn "git not configured to use delta"

printf '\n\033[1mSummary:\033[0m %d passed, %d warnings, %d failed\n' "$pass" "$warn" "$fail"
[[ "$fail" -eq 0 ]] && exit 0 || exit 1
