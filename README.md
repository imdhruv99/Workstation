# Workstation

My personal, reproducible development environment - a version-controlled set of
dotfiles and setup scripts that turn a fresh machine into a fully-configured
Machine Learning / DevOps workstation with a single copy-and-run.

---

## Why this exists

Setting up a new machine (or recovering an old one) shouldn't mean hours of
hunting for settings, re-installing tools, and half-remembering that one alias
you can't live without. This repo makes the environment:

- **Reproducible** - one script installs every tool and wires it in; safe to re-run.
- **Portable** - the layout mirrors the real target paths, so "install" is just a copy.
- **Modular** - features live in small, numbered files; add or remove one by
  dropping in or deleting a file, no monolith to untangle.
- **Fast** - tuned for sub-100 ms shell startup (lazy-loaded version managers,
  compiled completion cache).
- **Documented** - every alias, function, and key is listed, and there's a clear
  map of *which file to edit* when you add something new.

---

## Repository structure

Each top-level folder targets one platform. The internal layout mirrors where
files actually live on disk, so installation is a plain copy plus one script.

```
Workstation/
├── README.md          # you are here — overview + motive
└── macos/             # macOS setup (Ghostty + zsh)
    ├── README.md      # full install guide, architecture, troubleshooting
    ├── CHEATSHEET.md  # every alias/function/key + "where to add new things"
    ├── home/          # → copied to ~/ (currently just .zshenv)
    └── config/        # → copied to ~/.config/ (zsh, ghostty, starship)
```

---

## Platforms

| Platform | Status | Docs |
|---|---|---|
| **macOS** (Apple Silicon / Intel) | ✅ Complete | [macos/README.md](macos/README.md) · [macos/CHEATSHEET.md](macos/CHEATSHEET.md) |
| Linux | ⏳ Planned | — |
| Windows | ⏳ Planned | — |

---

## Quick start (macOS)

From the repo root:

```bash
REPO="$(pwd)/macos"
cp -a  "$REPO/home/.zshenv"  ~/.zshenv
mkdir -p ~/.config
cp -aR "$REPO/config/"*      ~/.config/

bash ~/.config/zsh/tools/bootstrap.sh   # install tooling + font (idempotent)
exec zsh                                # reload the shell
bash ~/.config/zsh/tools/healthcheck.sh # verify + benchmark
```

See [macos/README.md](macos/README.md) for prerequisites, the full config
architecture, verification checklist, troubleshooting, and rollback steps.

---

## Documentation

| Doc | Contents |
|---|---|
| [macos/README.md](macos/README.md) | Install, config architecture, load-order rules, troubleshooting, rollback |
| [macos/CHEATSHEET.md](macos/CHEATSHEET.md) | Full command reference (short form → actual command) + where to add new aliases/PATH/env/tools |

---

## Notes

- **No secrets in the repo.** Machine-local secrets go in `~/.config/zsh/.secrets`
  (git-ignored), sourced at runtime only if present.
- **Version-agnostic.** Tools are referenced by name and resolved via Homebrew /
  `pyenv` / `tfenv` / `uv`, so any machine gets current versions.
- **Idempotent scripts.** Safe to re-run for incremental updates.
