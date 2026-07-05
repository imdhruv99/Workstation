#!/usr/bin/env bash
# install.sh - install VS Code settings + extensions on macOS / Linux.
# Idempotent and safe to re-run. Symlinks settings.json so the repo stays the
# single source of truth; installs every extension listed in extensions.txt.
#
# Usage:
#   bash vscode/install.sh            # link settings + install extensions
#   bash vscode/install.sh --copy     # copy settings instead of symlinking
#   bash vscode/install.sh --no-ext   # skip extension installation

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COPY=0
INSTALL_EXT=1
for arg in "$@"; do
  case "$arg" in
    --copy)   COPY=1 ;;
    --no-ext) INSTALL_EXT=0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

# --- Resolve the User settings directory for this OS -------------------------
case "$(uname -s)" in
  Darwin) USER_DIR="$HOME/Library/Application Support/Code/User" ;;
  Linux)  USER_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/Code/User" ;;
  *) echo "Unsupported OS: $(uname -s). Use install.ps1 on Windows." >&2; exit 1 ;;
esac
mkdir -p "$USER_DIR"

# --- Link (or copy) settings.json with a timestamped backup ------------------
link_file() {
  local src="$1" dst="$2"
  [[ -f "$src" ]] || return 0
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    cp -a "$dst" "$dst.$(date +%Y%m%d-%H%M%S).bak"
    echo "backed up existing $(basename "$dst")"
  fi
  rm -f "$dst"
  if [[ "$COPY" -eq 1 ]]; then cp -a "$src" "$dst"; else ln -s "$src" "$dst"; fi
  echo "installed $(basename "$dst") -> $dst"
}

link_file "$SCRIPT_DIR/settings.json"    "$USER_DIR/settings.json"
link_file "$SCRIPT_DIR/keybindings.json" "$USER_DIR/keybindings.json"

# --- Install extensions ------------------------------------------------------
if [[ "$INSTALL_EXT" -eq 1 ]]; then
  if ! command -v code >/dev/null 2>&1; then
    echo "warning: 'code' CLI not found on PATH — skipping extensions." >&2
    echo "In VS Code run: Cmd/Ctrl+Shift+P -> 'Shell Command: Install code command in PATH'." >&2
  else
    # Corporate TLS inspection (Zscaler/Netskope/etc.) presents a certificate
    # that VS Code's bundled Node doesn't trust ("unable to get local issuer
    # certificate"), even when curl works. Point Node at the OS trust store.
    if [[ -z "${NODE_EXTRA_CA_CERTS:-}" && "$(uname -s)" == "Darwin" ]]; then
      _ca="$HOME/.config/node-extra-ca.pem"
      security find-certificate -a -p /Library/Keychains/System.keychain > "$_ca" 2>/dev/null || true
      security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain >> "$_ca" 2>/dev/null || true
      if [[ -s "$_ca" ]]; then
        export NODE_EXTRA_CA_CERTS="$_ca"
        echo "using OS certificate bundle: $_ca"
      fi
    fi

    # Don't let one failing extension abort the batch; report failures at the end.
    _failed=()
    while IFS= read -r ext; do
      ext="${ext%%#*}"; ext="$(echo "$ext" | xargs)"   # strip comments + whitespace
      [[ -z "$ext" ]] && continue
      code --install-extension "$ext" --force || _failed+=("$ext")
    done < "$SCRIPT_DIR/extensions.txt"

    if [[ ${#_failed[@]} -gt 0 ]]; then
      echo "" >&2
      echo "WARNING: ${#_failed[@]} extension(s) failed to install:" >&2
      printf '  - %s\n' "${_failed[@]}" >&2
      echo "Re-run this script to retry, or check network/proxy/certificate settings." >&2
    else
      echo "extensions installed."
    fi
  fi
fi

echo "VS Code setup complete. Reload the window to apply."
