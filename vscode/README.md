# VS Code Setup (cross-platform)

OS-agnostic Visual Studio Code configuration — shared `settings.json` and a
curated extension set — for **software development, full-stack engineering, AI,
Machine Learning, Deep Learning, Big Data, and DevOps**. One install script per
platform; identical experience on macOS, Linux, and Windows.

> Tuned to stay **fast and reliable**: aggressive file-watcher / search excludes
> for `node_modules`, `.venv`, build dirs, etc.; per-language formatters pinned
> explicitly; version-manager-agnostic interpreter discovery; a lean, official
> extension list with no overlapping duplicates.

---

## Install

### macOS / Linux

```bash
# from the repo root
bash vscode/install.sh            # symlink settings + install all extensions
# options:
#   --copy     copy settings.json instead of symlinking
#   --no-ext   skip extension installation
```

### Windows (PowerShell)

```powershell
# from the repo root
powershell -ExecutionPolicy Bypass -File vscode\install.ps1
# option: -NoExt   skip extension installation
```

The script backs up any existing `settings.json` (timestamped `.bak`), then
links/copies this repo's copy into the VS Code **User** directory and installs
every extension in [extensions.txt](extensions.txt). Re-run it any time to sync.

> Requires the `code` CLI on `PATH`. If missing, open VS Code and run
> **Cmd/Ctrl+Shift+P → "Shell Command: Install 'code' command in PATH"**.

---

## Where files land per OS

| OS | User settings directory |
|---|---|
| macOS | `~/Library/Application Support/Code/User/` |
| Linux | `~/.config/Code/User/` |
| Windows | `%APPDATA%\Code\User\` |

`settings.json` (and `keybindings.json` if present) are placed here. On
macOS/Linux they are symlinked back to this repo so edits stay version-controlled;
on Windows they are copied (symlinks need admin).

---

## What's configured (`settings.json`)

| Area | Highlights |
|---|---|
| **Performance** | `files.watcherExclude` / `search.exclude` / `files.exclude` for `node_modules`, `.venv`, `__pycache__`, `target`, `dist`, `build`, `.next`, `.terraform`, `.gradle`, …; preview editors + minimap off; autofetch off |
| **IntelliSense** | Auto-import completions on, word-based + trigger-char suggestions, first-match selection |
| **Python / Pylance** | `autoImportCompletions`, indexing on, tuned `packageIndexDepths` (pydantic, fastapi, django, sqlalchemy…), autopep8 formatter |
| **Go** | gopls, `goimports`, `golangci-lint` on save |
| **Java** | auto build config, JDT LS VM args, organize-imports on save |
| **JS / TS** | modern `js/ts.*` keys, update-imports-on-move, larger tsserver memory |
| **YAML / DevOps** | schema store on; k8s / docker-compose / GitHub Actions schemas mapped |
| **Formatters** | one explicit `defaultFormatter` per language — no silent fallback |
| **File hygiene** | final newline, trim trailing whitespace/newlines |

To change or add a setting, edit [settings.json](settings.json) and re-run the
installer (or, if symlinked, changes apply live on reload).

---

## Extensions by area (`extensions.txt`)

| Area | Extensions |
|---|---|
| **Editor & Git** | GitLens, Copilot (+ Chat), GitHub Pull Requests, Material Icon Theme, EditorConfig, Error Lens, Path Intellisense, Todo Tree |
| **Python / AI / ML / DL** | Python, Pylance, debugpy, autopep8, Python Envs, Ruff, autoDocstring, Jupyter (+ keymap, renderers, cell tags, slideshow), TensorBoard, Data Wrangler |
| **Web / Full-stack** | Prettier, ESLint, Auto Rename Tag |
| **Go** | Go |
| **Java** | Java Pack, Red Hat Java |
| **C / C++** | C/C++ Extension Pack |
| **Build / general dev** | Makefile Tools, XML, markdownlint |
| **DevOps / Cloud / IaC** | Docker, Kubernetes, Terraform, YAML, GitHub Actions |
| **Big Data / SQL / data files** | SQLTools (+ PostgreSQL / MySQL / SQLite drivers), Rainbow CSV |
| **Shell / configs** | ShellCheck, shell-format, Even Better TOML |
| **Remote dev** | Remote Development pack (SSH, Dev Containers, WSL, Tunnels) |

Add or remove one by editing [extensions.txt](extensions.txt) (one id per line;
`#` comments allowed) and re-running the installer.

---

## Update / uninstall

- **Update** — edit `settings.json` / `extensions.txt`, re-run the install script.
- **Roll back settings** — restore the timestamped `settings.json.*.bak` from the
  User directory.
- **Remove an extension** — `code --uninstall-extension <id>`.

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `unable to get local issuer certificate` on install (but `curl` works) | Corporate TLS inspection (Zscaler/Netskope/etc.); VS Code's bundled Node ignores the macOS keychain | The installer auto-exports the OS trust store to `~/.config/node-extra-ca.pem` and sets `NODE_EXTRA_CA_CERTS`. To fix other Node/CLI tools too, add `export NODE_EXTRA_CA_CERTS="$HOME/.config/node-extra-ca.pem"` to your shell env |
| `... is a built-in extension ... cannot be downgraded` | Copilot / Copilot Chat now ship built-in with VS Code | Expected — they're intentionally excluded from `extensions.txt`; no action needed |
| A few extensions fail mid-run | Transient network / marketplace hiccup | Re-run `install.sh`; it continues past failures and lists what to retry |
