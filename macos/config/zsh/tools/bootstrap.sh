#!/usr/bin/env bash
# bootstrap.sh - idempotent installer for the Ghostty + zsh power setup.
# Safe to re-run. Backs up any pre-existing target files before touching them.
# Usage:  bash ~/.config/zsh/tools/bootstrap.sh
set -euo pipefail

# ------------------------------------------------------------------ helpers --
log()  { printf '\033[1;34m[*]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[✓]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; exit 1; }

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

# ------------------------------------------------------- preconditions -------
[[ "$(uname -s)" == "Darwin" ]] || die "This script targets macOS."
command -v brew >/dev/null 2>&1 || die "Homebrew not found. Install from https://brew.sh first."

# --------------------------------------------------------- formulae ----------
# Required core tooling.
REQUIRED_FORMULAE=(
  starship eza bat fd ripgrep fzf zoxide git-delta gh jq yq
  zsh-autosuggestions zsh-syntax-highlighting
  atuin direnv
  kubectx k9s stern
  uv pipx
)
# Optional / nice-to-have (comment out any you don't want).
OPTIONAL_FORMULAE=(
  btop procs dust duf tldr fast-syntax-highlighting
)

log "Updating Homebrew…"
brew update >/dev/null || warn "brew update failed (continuing with cached state)."

install_formula() {
  local f="$1"
  if brew list --formula "$f" >/dev/null 2>&1; then
    ok "already installed: $f"
  else
    log "installing: $f"
    brew install "$f" || warn "failed to install $f (continuing)."
  fi
}

log "Installing required formulae…"
for f in "${REQUIRED_FORMULAE[@]}"; do install_formula "$f"; done

log "Installing optional formulae…"
for f in "${OPTIONAL_FORMULAE[@]}"; do install_formula "$f"; done

# --------------------------------------------------------- nerd font ---------
if brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1; then
  ok "already installed: JetBrainsMono Nerd Font"
else
  log "installing JetBrainsMono Nerd Font…"
  brew install --cask font-jetbrains-mono-nerd-font || warn "font install failed."
fi

# --------------------------------------------------------- backups -----------
# Back up any file we manage IF it exists and is NOT already our config.
backup_if_exists() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    # Only back up files not already part of this setup (heuristic: home dotfiles).
    cp -a "$target" "${target}.${STAMP}.bak"
    warn "backed up existing $target -> ${target}.${STAMP}.bak"
  fi
}

# The only home-level file we own is ~/.zshenv.
if [[ -f "$HOME/.zshenv" ]] && ! grep -q 'ZDOTDIR' "$HOME/.zshenv" 2>/dev/null; then
  backup_if_exists "$HOME/.zshenv"
  warn "Your existing ~/.zshenv does not set ZDOTDIR. Review the backup and merge."
fi

# --------------------------------------------------------- fzf key-bindings --
# Modern fzf uses `fzf --zsh`; nothing to install. Older setups may need:
# "$(brew --prefix)/opt/fzf/install" --no-bash --no-fish --key-bindings --completion --no-update-rc

# --------------------------------------------------------- dirs --------------
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" \
         "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" \
         "${XDG_STATE_HOME:-$HOME/.local/state}/less"

# --------------------------------------------------------- git delta ---------
# Wire delta into git as the pager (idempotent — only sets if not already delta).
if command -v delta >/dev/null 2>&1; then
  if [[ "$(git config --global core.pager || true)" != "delta" ]]; then
    git config --global core.pager delta
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global delta.navigate true
    git config --global delta.line-numbers true
    git config --global merge.conflictStyle zdiff3
    ok "configured git to use delta"
  else
    ok "git already using delta"
  fi
fi

ok "Bootstrap complete. Open a new Ghostty window or run: exec zsh"
log "Then verify with: bash ~/.config/zsh/tools/healthcheck.sh"
