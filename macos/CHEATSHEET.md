# macOS Workstation — Command Cheat Sheet

Every alias and function shipped in `config/zsh/conf.d/`, grouped by module.
Format: **short form | actual command / what it runs**.

> Aliases fall back gracefully — if a modern tool isn't installed, the classic
> command is used (or the alias is simply not defined).

---

## Listing & files — `70-aliases.zsh`

| Short form | Actual command |
|---|---|
| `ls` | `eza --group-directories-first --icons=auto` |
| `ll` | `eza -lh --group-directories-first --icons=auto --git` |
| `la` | `eza -lah --group-directories-first --icons=auto --git` |
| `lt` | `eza --tree --level=2 --icons=auto` |
| `ltt` | `eza --tree --level=4 --icons=auto` |
| `cat` | `bat --paging=never` |
| `catp` | `bat` (with paging) |
| `grep` | `rg` (ripgrep) |
| `find` | `fd` |
| `ps` | `procs` |
| `du` | `dust` |
| `df` | `duf` |
| `top` | `btop` |

## Navigation — `70-aliases.zsh`

| Short form | Actual command |
|---|---|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |
| `-` | `cd -` (previous dir) |
| `mkdir` | `mkdir -p` |

## Safety — `70-aliases.zsh`

| Short form | Actual command |
|---|---|
| `rm` | `rm -i` (confirm each delete) |
| `cp` | `cp -i` (confirm overwrite) |
| `mv` | `mv -i` (confirm overwrite) |

## Config / misc — `70-aliases.zsh`

| Short form | Actual command |
|---|---|
| `reload` | `exec zsh` (restart shell) |
| `zshrc` | `$EDITOR "$ZDOTDIR/.zshrc"` |
| `zconf` | `cd "$ZDOTDIR/conf.d"` |
| `path` | print `$PATH`, one entry per line |
| `now` | `date +"%Y-%m-%d %H:%M:%S"` |
| `ip` | `curl -s ifconfig.me` (public IP) |
| `please` | `sudo $(fc -ln -1)` (re-run last cmd with sudo) |

---

## Git aliases — `75-aliases-git.zsh`

| Short form | Actual command |
|---|---|
| `g` | `git` |
| `gs` | `git status -sb` |
| `gss` | `git status` |
| `ga` | `git add` |
| `gaa` | `git add --all` |
| `gc` | `git commit -v` |
| `gcm` | `git commit -m` |
| `gca` | `git commit --amend` |
| `gcan` | `git commit --amend --no-edit` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gsw` | `git switch` |
| `gswc` | `git switch -c` |
| `gb` | `git branch` |
| `gbd` | `git branch -d` |
| `gbD` | `git branch -D` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `gl` | `git log --oneline --graph --decorate -20` |
| `gla` | `git log --oneline --graph --decorate --all -30` |
| `gp` | `git push` |
| `gpf` | `git push --force-with-lease` |
| `gpu` | `git push -u origin HEAD` |
| `gpl` | `git pull --rebase --autostash` |
| `gf` | `git fetch --all --prune` |
| `grb` | `git rebase` |
| `grbi` | `git rebase -i` |
| `grbc` | `git rebase --continue` |
| `grba` | `git rebase --abort` |
| `grbm` | `git rebase origin/<main-branch>` |
| `gst` | `git stash` |
| `gstp` | `git stash pop` |
| `gstl` | `git stash list` |
| `grh` | `git reset HEAD` |
| `grhh` | `git reset --hard` (destructive) |

### Git functions

| Function | What it does |
|---|---|
| `git_main_branch` | Resolve repo's main branch name (`main` vs `master`) |
| `gbf` | Fuzzy-pick a branch (local/remote) via fzf and `git switch` to it |

---

## General functions — `80-functions.zsh`

| Function | What it does |
|---|---|
| `mkcd <dir>` | `mkdir -p <dir>` then `cd` into it |
| `extract <file>` | Unpack any common archive by extension (tar/gz/zip/7z/rar…) |
| `ff` | Fuzzy-find a file (fzf + bat preview), open in `$EDITOR` |
| `fcd` | Fuzzy-find a directory (fd + fzf), `cd` into it |
| `proj` | Fuzzy-jump to a project under `~/code`, `~/projects`, `~/work`, `~/src` |
| `rgf <pat>` | ripgrep + fzf content search, open match at line in `$EDITOR` |
| `backup <file>` | Timestamped copy: `<file>.YYYYmmdd-HHMMSS.bak` |
| `zsh-bench` | Measure interactive startup time (10 runs) |

---

## Docker — `85-devops.zsh`

| Short form | Actual command |
|---|---|
| `d` | `docker` |
| `dc` | `docker compose` |
| `dps` | `docker ps` (formatted: names, status, ports) |
| `dpsa` | `docker ps -a` (formatted: names, status, image) |
| `dimg` | `docker images` |
| `dexec` | `docker exec -it` |
| `dlogs` | `docker logs -f --tail=200` |

| Function | What it does |
|---|---|
| `dsh` | Fuzzy-pick a running container and shell in (bash → sh) |
| `dclean` | `docker system prune -f` (dangling images/containers/networks) |
| `dcleanall` | **Destructive:** prune ALL unused images + volumes (confirms first) |

## Kubernetes — `85-devops.zsh`

| Short form | Actual command |
|---|---|
| `k` | `kubectl` |
| `kg` | `kubectl get` |
| `kgp` | `kubectl get pods` |
| `kgpa` | `kubectl get pods -A` |
| `kgs` | `kubectl get svc` |
| `kgd` | `kubectl get deploy` |
| `kgn` | `kubectl get nodes -o wide` |
| `kd` | `kubectl describe` |
| `kaf` | `kubectl apply -f` |
| `kdel` | `kubectl delete` |
| `kl` | `kubectl logs -f --tail=200` |
| `kex` | `kubectl exec -it` |
| `kctx` | `kubectx` (switch cluster context) |
| `kns` | `kubens` (switch namespace) |

| Function | What it does |
|---|---|
| `kpick` | Fuzzy-select context AND namespace in one flow |
| `klf [sel]` | Multi-pod log tailing with `stern` (default selector `.`) |
| `kshell` | Fuzzy-pick a pod in current namespace and exec a shell |

## Terraform — `85-devops.zsh`

| Short form | Actual command |
|---|---|
| `tf` | `terraform` |
| `tfi` | `terraform init` |
| `tfp` | `terraform plan` |
| `tfa` | `terraform apply` |
| `tfd` | `terraform destroy` (destructive) |
| `tff` | `terraform fmt -recursive` |
| `tfv` | `terraform validate` |
| `tfw` | `terraform workspace` |

## Cloud — `85-devops.zsh`

| Short form / fn | Actual command / action |
|---|---|
| `gcp` | `gcloud config configurations` |
| `gcpx` | Fuzzy-switch active gcloud configuration |
| `awsx` | Fuzzy-switch AWS profile (sets `AWS_PROFILE`) |

---

## Python / venv — `90-ml.zsh`

| Short form | Actual command |
|---|---|
| `py` | `python3` |
| `pip` | `python3 -m pip` |
| `venv` | `python3 -m venv .venv` |
| `va` | `source .venv/bin/activate` |
| `da` | `deactivate` |

| Function | What it does |
|---|---|
| `mkvenv [dir]` | Create + activate venv (default `.venv`) and upgrade pip |
| `autovenv` | Auto-activate `./.venv` on `cd` (runs via `chpwd` hook) |

## uv (fast pip/venv) — `90-ml.zsh`

| Short form | Actual command |
|---|---|
| `uvs` | `uv sync` (sync deps from lockfile) |
| `uvr` | `uv run` (run in project env) |
| `uva` | `uv add` (add dependency) |
| `uvrm` | `uv remove` (remove dependency) |
| `uvpip` | `uv pip` (pip-compatible interface) |
| `uvx` | `uv tool run` (run a tool ephemerally) |

## Jupyter — `90-ml.zsh`

| Short form / fn | Actual command |
|---|---|
| `jl` | `jupyter lab` |
| `jn` | `jupyter notebook` |
| `jlp [port]` | `jupyter lab --no-browser --port=<8888>` (good over SSH) |
| `nbclean` | Strip notebook output (nbstripout) |

## GPU / cleanup — `90-ml.zsh`

| Short form / fn | Actual command / action |
|---|---|
| `gpu` | `nvidia-smi` if present, else note about Apple MPS |
| `watchgpu` | `watch -n1 nvidia-smi` (live GPU utilization) |
| `pyclean` | Remove `__pycache__` dirs and `.pyc` files under `$PWD` |

---

## Version managers & env tools — `95-tools.zsh`

These are **integrations**, not commands you type differently. They wire up:

| Tool | Behavior |
|---|---|
| `direnv` | Hooked into zsh; auto-loads `.envrc` per directory |
| `pyenv` | **Lazy-loaded** on first use of `pyenv`/`python`/`python3`/`pip`/`pip3` |
| `jenv` | **Lazy-loaded** (Java) on first use of `jenv` |
| `tfenv` | Shim already on `PATH` via Homebrew (no init needed) |
| `gcloud` | Sources SDK `path` + `completion` if the SDK dir is present |

---

## Plugins & keys — `50-plugins.zsh` / `60-keybindings.zsh`

| Key / plugin | Action |
|---|---|
| `Ctrl-Space` | Accept the inline autosuggestion |
| `↑` / `↓` | History substring search from what's typed |
| `Option+←` / `Option+→` | Move backward / forward one word |
| `Ctrl-X Ctrl-E` | Edit current command line in `$EDITOR` |
| `Home` / `End` | Beginning / end of line |
| `Ctrl-R` | atuin history search |
| `Ctrl-T` | fzf file picker |
| `Alt-C` | fzf directory picker (`cd`) |
| `z <dir>` | zoxide frecency jump |
| `zi` | zoxide interactive pick |

---

## Ghostty terminal keys — `config/ghostty/config`

| Key | Action |
|---|---|
| `Cmd+D` | New split to the right |
| `Cmd+Shift+D` | New split downward |
| `Cmd+Alt+←/→/↑/↓` | Move focus between splits |
| `Cmd+Shift+Enter` | Zoom / unzoom the focused split |
| `Cmd+T` | New tab |
| `Cmd+W` | Close split / tab |
| `Cmd+Shift+←` / `Cmd+Shift+→` | Previous / next tab |
| `Cmd+K` | Clear screen + scrollback |
| `Cmd+0` | Reset font size |
| `Cmd+Shift+,` | Reload Ghostty config |

---

## Shell behavior & gotchas — `00-options.zsh` / `30-history.zsh`

| You type / do | Effect |
|---|---|
| `<dir>` (bare) | `AUTO_CD` — cd's into it if it's a directory |
| `> file` | Won't overwrite an existing file (`NO_CLOBBER`) |
| `>\| file` | Force overwrite (bypass `NO_CLOBBER`) |
| ` cmd` (leading space) | Command is kept out of history (`HIST_IGNORE_SPACE`) |
| `!!` / `!$` | History expansion (shown before running — `HIST_VERIFY`) |
| `rm *` | 10-second safety pause before running (`RM_STAR_WAIT`) |
| `# comment` | Allowed at the interactive prompt (`INTERACTIVE_COMMENTS`) |
| `Ctrl-S` / `Ctrl-Q` | Free for keybindings (flow control disabled) |
| duplicate commands | Collapsed; history shared live across open shells |

---

## Helper scripts — `config/zsh/tools/`

| Command | What it does |
|---|---|
| `bash ~/.config/zsh/tools/bootstrap.sh` | Idempotent installer: tools, Nerd Font, git-delta, state dirs |
| `bash ~/.config/zsh/tools/healthcheck.sh` | Read-only verification report + startup benchmark |
| `zsh-bench` | Quick interactive startup timing (10 runs) |

---

# Where to add new things

The config is modular: `.zshrc` sources every file in `conf.d/` in numeric order.
Pick the file by **what** you're adding — never edit `.zshrc` itself.

| I want to… | Edit this file | Where / how |
|---|---|---|
| **Install a new CLI tool** | `config/zsh/tools/bootstrap.sh` | Add the formula/cask to the Homebrew install list so it's reproducible |
| **Add a new alias** | `conf.d/70-aliases.zsh` (general) | Add `alias name='command'`. Guard with `command -v tool >/dev/null 2>&1 &&` if it depends on a tool |
| **Add a git alias** | `conf.d/75-aliases-git.zsh` | Add `alias g…='git …'` |
| **Add a Docker/k8s/Terraform/cloud alias or fn** | `conf.d/85-devops.zsh` | Add under the matching section header |
| **Add a Python / ML / Jupyter alias or fn** | `conf.d/90-ml.zsh` | Add under the matching section header |
| **Add a general shell function** | `conf.d/80-functions.zsh` | Define `name() { … }` |
| **Add / change a PATH entry** | `conf.d/20-path.zsh` | Add to the `path=( … )` array, or to the `for _p in …` loop (only added if the dir exists). Dedup is automatic (`typeset -U path`) |
| **Add PATH for login/non-interactive too** | `config/zsh/.zprofile` | For env all login shells need (e.g. Homebrew, base bins) |
| **Add an environment variable** | `conf.d/10-exports.zsh` | Add `export VAR=value` |
| **Add a secret / token (never committed)** | `~/.config/zsh/.secrets` | Auto-sourced by `10-exports.zsh` if present; git-ignored |
| **Add a keybinding** | `conf.d/60-keybindings.zsh` | `bindkey '<seq>' <widget>` |
| **Add an interactive plugin** | `conf.d/50-plugins.zsh` | Source it here (but NOT syntax-highlighting) |
| **Enable a version manager** (pyenv/jenv/tfenv/gcloud/direnv) | `conf.d/95-tools.zsh` | Add a lazy-load block to protect startup time |
| **Change prompt / syntax highlighting** | `conf.d/99-prompt.zsh` + `config/starship.toml` | Highlighting must stay LAST so it wraps all widgets |
| **Add a whole new feature area** | new file `conf.d/NN-name.zsh` | Pick a number for load order; no `.zshrc` edit needed |
| **Add XDG dir / ZDOTDIR level env** | `home/.zshenv` | Only for tiny, side-effect-free vars that ALL zsh invocations need |

### Load-order rules (don't break these)

1. `40-completion.zsh` runs `compinit` **before** any plugin that adds completions.
2. `99-prompt.zsh` loads syntax highlighting **last** so it can wrap all widgets.
3. Slow initializers (`pyenv`, `jenv`, `gcloud`) are **lazy-loaded** in `95-tools.zsh`
   to keep startup fast.

### After any change

```bash
exec zsh                                   # reload the shell (or: reload)
bash ~/.config/zsh/tools/healthcheck.sh    # verify + benchmark startup
```
