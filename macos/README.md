# macOS Workstation Setup

Production-quality **Ghostty + zsh** environment for a Machine Learning / DevOps
workflow: modular zsh config, fast startup, fuzzy navigation, syntax highlighting,
autosuggestions, and best-in-class modern CLI tooling.

> Everything here mirrors its real target location, so installation is a plain copy:
> `macos/home/` → `~/` and `macos/config/` → `~/.config/`, then run one script.

---

## 1. Prerequisites

| Requirement | Check | Install |
|---|---|---|
| macOS (Apple Silicon or Intel) | `uname -sm` | - |
| Homebrew | `brew --version` | `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` |
| Ghostty | `ghostty --version` | `brew install --cask ghostty` |
| zsh (default on macOS) | `zsh --version` | preinstalled |

---

## 2. Install (copy → run)

From the repo root:

```bash
# 1. Copy config into place (creates ~/.config if missing).
#    -a preserves modes/timestamps; adjust the repo path if different.
REPO="$(pwd)/macos"          # run from the Workstation repo root
cp -a  "$REPO/home/.zshenv"  ~/.zshenv
mkdir -p ~/.config
cp -aR "$REPO/config/"*      ~/.config/

# 2. Install all tooling + Nerd Font, wire git-delta, create state dirs.
#    Idempotent — safe to re-run.
bash ~/.config/zsh/tools/bootstrap.sh

# 3. Reload the shell.
exec zsh

# 4. Verify (read-only report + startup benchmark).
bash ~/.config/zsh/tools/healthcheck.sh
```

> **Back up first (optional but recommended):** if you already have these files,
> `bootstrap.sh` backs up `~/.zshenv` when it doesn't set `ZDOTDIR`. For a full
> manual safety net: `cp -a ~/.zshenv ~/.zshenv.bak 2>/dev/null; cp -aR ~/.config ~/.config.bak`.

Then set the font in **Ghostty → Settings** (or it's already read from the config):
`JetBrainsMono Nerd Font`. Reload Ghostty config in-app with `Cmd+Shift+,`.

---

## 3. What gets installed

Installed by `tools/bootstrap.sh` via Homebrew.

### Required

| Tool | Purpose |
|---|---|
| `starship` | Fast, git/k8s/python-aware prompt |
| `eza` | Modern `ls` (icons, git status, tree) |
| `bat` | `cat` with syntax highlighting + paging |
| `fd` | Fast, intuitive `find` |
| `ripgrep` (`rg`) | Fast recursive code search |
| `fzf` | Fuzzy finder (files, history, processes) |
| `zoxide` | Frecency-based directory jumping (`z`) |
| `git-delta` | Syntax-highlighted git diffs |
| `gh` | GitHub CLI |
| `jq` / `yq` | JSON / YAML processors |
| `atuin` | SQLite shell history + better `Ctrl-R` |
| `direnv` | Per-directory environments (`.envrc`) |
| `kubectx` / `kubens` | Fast k8s context / namespace switching |
| `k9s` | Kubernetes TUI dashboard |
| `stern` | Multi-pod Kubernetes log tailing |
| `uv` | Ultra-fast Python env / package manager |
| `pipx` | Isolated installs of Python CLI tools |
| JetBrainsMono Nerd Font | Ligatures + dev/powerline glyphs |

### Optional (nice-to-have)

| Tool | Purpose |
|---|---|
| `btop` | Rich system/process monitor |
| `procs` | Modern `ps` |
| `dust` | Intuitive `du` |
| `duf` | Friendly `df` |
| `tldr` | Practical command examples |
| `fast-syntax-highlighting` | Faster alternative to zsh-syntax-highlighting |

### Preserved existing integrations

`git`, `pyenv`, `jenv`, `tfenv`, `kubectl`, `gcloud`, `aws-okta` - detected and
wired in non-destructively (slow ones are lazy-loaded).

---

## 4. Config architecture

`.zshrc` sources every module in `conf.d/` in numeric order. Add a feature by
dropping in a new numbered file; remove one by deleting its file.

```
~/.zshenv                      # sets XDG dirs + ZDOTDIR=~/.config/zsh (only file in $HOME)
~/.config/
├── zsh/
│   ├── .zprofile              # login shell: brew shellenv, base PATH
│   ├── .zshrc                 # loader: sources conf.d/*.zsh in order
│   ├── conf.d/
│   │   ├── 00-options.zsh     # setopt + safety guard rails
│   │   ├── 10-exports.zsh     # env vars (+ optional .secrets)
│   │   ├── 20-path.zsh        # PATH management (deduplicated)
│   │   ├── 30-history.zsh     # smart, shared, deduped history
│   │   ├── 40-completion.zsh  # compinit + styles (cached/zcompiled)
│   │   ├── 50-plugins.zsh     # autosuggestions, zoxide, fzf, atuin
│   │   ├── 60-keybindings.zsh # emacs keys + history search + widgets
│   │   ├── 70-aliases.zsh     # general aliases (eza/bat/fd/rg…)
│   │   ├── 75-aliases-git.zsh # git shortcuts
│   │   ├── 80-functions.zsh   # general functions (mkcd, ff, rgf, proj…)
│   │   ├── 85-devops.zsh      # docker + k8s + terraform + cloud
│   │   ├── 90-ml.zsh          # python / uv / jupyter / gpu helpers
│   │   ├── 95-tools.zsh       # pyenv/jenv/tfenv/gcloud/direnv (lazy)
│   │   └── 99-prompt.zsh      # starship + syntax-highlighting (LAST)
│   └── tools/
│       ├── bootstrap.sh       # idempotent installer
│       └── healthcheck.sh     # verifies setup + benchmarks startup
├── ghostty/
│   └── config                 # Ghostty terminal settings
└── starship.toml              # prompt theme + modules
```

### Load-order rules (don't break these)

- `40-completion.zsh` runs `compinit` **before** any plugin that adds completions.
- `99-prompt.zsh` loads syntax highlighting **last** so it can wrap all widgets.
- Slow initializers (`pyenv`, `jenv`, `gcloud`) are **lazy-loaded** to keep startup fast.

---

## 5. Cheat sheet

> Condensed highlights below. For **every** alias/function in table form plus a
> "where to add new things" guide, see [CHEATSHEET.md](CHEATSHEET.md).

### Navigation & files
| Command | Does |
|---|---|
| `z <dir>` / `zi` | Jump to frecent dir / interactive pick |
| `ll`, `la`, `lt` | eza long / all / tree |
| `ff` | Fuzzy-find a file, open in `$EDITOR` |
| `fcd` | Fuzzy-find a dir and `cd` |
| `rgf <pat>` | Search content, open match at line |
| `proj` | Fuzzy-jump to a project under ~/code, ~/work, … |
| `mkcd <dir>` | mkdir + cd |
| `extract <file>` | Unpack any common archive |

### Git
`g`, `gs`, `gaa`, `gc`, `gcm`, `gco`, `gcb`, `gsw`, `gl`, `gp`, `gpf` (force-with-lease),
`gpl` (pull --rebase --autostash), `grb*`, `gst*`, `gbf` (fuzzy branch switch).

### Docker
`d`, `dc`, `dps`, `dlogs`, `dsh` (fuzzy shell into container), `dclean`, `dcleanall` (confirms).

### Kubernetes
`k`, `kgp`, `kgpa`, `kl`, `kex`, `kctx`, `kns`, `kpick` (fuzzy context+namespace),
`klf` (stern tail), `kshell` (fuzzy exec into pod).

### Terraform / Cloud
`tf`, `tfi`, `tfp`, `tfa`, `tff`, `tfw`; `gcpx` (switch gcloud config), `awsx` (switch AWS profile).

### Python / ML
`py`, `mkvenv`, `va`/`da` (activate/deactivate), auto-activate `./.venv` on `cd`,
`uvs`/`uvr`/`uva` (uv), `jl`/`jn`/`jlp` (Jupyter), `pyclean`, `gpu`.

### Misc
`reload` (`exec zsh`), `zshrc`/`zconf` (edit config), `path`, `please` (re-run last with sudo),
`zsh-bench` (measure startup time).

---

## 6. Ghostty highlights

- **Font**: JetBrainsMono Nerd Font, ligatures on.
- **Theme**: catppuccin-mocha, slight transparency + blur.
- **Splits**: `Cmd+D` (right), `Cmd+Shift+D` (down), `Cmd+Alt+Arrows` to move, `Cmd+Shift+Enter` zoom.
- **Tabs**: `Cmd+T`, `Cmd+Shift+←/→`.
- **Copy-on-select**, 100k scrollback, shell integration for cwd + prompt marks.
- Reload config: `Cmd+Shift+,`.

---

## 7. Verify

```bash
bash ~/.config/zsh/tools/healthcheck.sh
```

Checklist:
- [ ] New window shows the two-line Starship prompt, no errors.
- [ ] Dim grey autosuggestions appear; `Ctrl-Space` accepts.
- [ ] Valid commands green / invalid red (syntax highlighting).
- [ ] `Ctrl-R` atuin search, `Ctrl-T` files, `Alt-C` dirs.
- [ ] `z`, `ll`, `cat`, `grep`, `k get pods`, `gbf` all work.
- [ ] `cd` into a folder with `.venv` auto-activates it.
- [ ] `zsh-bench` reports ~30–70 ms after cache warms.

---

## 8. Measure startup performance

```bash
zsh-bench                     # 10 timed interactive-shell launches
```

For a per-line profile, uncomment `zmodload zsh/zprof` (top) and `zprof` (bottom)
in `~/.config/zsh/.zshrc`, then open a new shell.

---

## 9. Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Config not loading | `ZDOTDIR` not set | `echo $ZDOTDIR`; ensure `~/.zshenv` has it |
| Boxes / missing glyphs | Nerd Font not active | Install font (bootstrap does), set it in Ghostty |
| `defining function based on alias` | alias/function name clash | Fixed in `95-tools.zsh` (unaliases first); `exec zsh` |
| `compinit: insecure directories` | brew dir perms | `chmod -R go-w "$(brew --prefix)/share"` then delete `~/.cache/zsh/zcompdump*` |
| Slow startup | eager init | Lazy in `95-tools.zsh`; run `zsh-bench` / `zprof` |
| `Ctrl-R` not atuin | atuin missing | `brew install atuin && exec zsh` |
| Stale completions | cached dump | `rm -f ~/.cache/zsh/zcompdump*; exec zsh` |

---

## 10. Rollback

1. Restore backups: `~/.zshenv.*.bak` (created by bootstrap) and any manual `~/.config.bak`.
2. Remove managed files:
   ```bash
   rm -f ~/.zshenv ~/.config/starship.toml ~/.config/ghostty/config
   rm -rf ~/.config/zsh
   ```
3. Uninstall tools if desired: `brew uninstall <name>` (see the tables in §3).

---

## 11. Optional enhancements

- **direnv** — already hooked; add `.envrc` with `layout python` for auto per-project envs.
- **tmux** — `brew install tmux` for persistent/remote sessions.
- **Colima** — `brew install colima docker` as a license-clean Docker Desktop alternative.
- **Secrets** — put machine-local secrets in `~/.config/zsh/.secrets` (git-ignored, auto-sourced).
- **k9s config** — `~/.config/k9s/config.yaml` to customize the TUI.

---

## 12. Notes

- No secrets are stored in this repo; `.secrets` is sourced at runtime only if present.
- Configs are version-agnostic: tools are referenced by name and resolved via
  `pyenv`/`tfenv`/`uv`/Homebrew, so any machine gets current versions.
- Scripts are idempotent and safe to re-run for incremental updates.
