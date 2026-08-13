# Mac migration report

**Old machine:** macOS 26.5.2, arm64, shell `/opt/homebrew/bin/fish`
**Audited:** 13 Aug 2026 — 129 git repos + 20 loose folders across `~/development` and `~/code`, plus 31 submodules inside `esim-iot-base` and `onomondo-base`.
**Strategy:** clean install, no Migration Assistant. `~/code/dotfiles` becomes the source of truth.

---

## The short version

Three things actually matter, in this order:

1. **Push or archive ~62 local-only git branches and 32 stashes.** Most live in *submodules* of `onomondo-base` and `esim-iot-base`, which is easy to miss because the parent repo looks clean. This is the only genuinely unrecoverable stuff on the machine.
2. **Your dotfiles repo covers about 40% of the machine.** Biggest gaps: no Brewfile (80 top-level formulae + 12 casks installed, README lists ~15), and three untracked fish function files including your prompt.
3. **Everything else is re-cloneable or re-installable.** Of 129 repos, ~30 are worth putting back; the rest are upstream clones and one-off scratch.

Alongside this report: `repo-audit.csv` has the raw per-repo data (all 152 rows) if you want to sort it yourself.

---

## 1. At-risk work — do this before you wipe

### 1a. Repos with NO remote at all

These exist only on this disk. If the folder goes, the history goes.

| Repo | Commits | Last | Notes |
|---|---|---|---|
| `development/modem-playing` | 3 local | 2026-01-22 | "Add SSH attach mode", "atsh MVP shell with parser and tests" — real work, and `~/.atsh_history` in your home says you used it |
| `code/temple` | 3 on `claude-tries`, 1 on `main` | 2025-08-27 | "TypeScript barebones framework with ORM, auth, rights management" + README. Also 3 dirty files |
| `development/dynamotesting` | 7 local | 2024-07-26 | 3 dirty files. Old but never pushed anywhere |
| `development/backoffice2` | 2 local | 2025-01-27 | Same two commits also exist on `onomondo-base` branch `jfo/backoffice`, so partially duplicated |
| `code/log-rep` | 2 local | 2025-04-08 | "port", "docker" + untracked `setup-main.sql` |
| `development/sns-fix` | 1 local | 2025-12-08 | Single "init" commit |
| `code/logical-replication` | 0 commits | — | Not a real repo. Has `main.tf` + **`terraform.tfstate`** |
| `code/tock` | 0 commits | — | Empty repo, one untracked file `one` |

**Suggested:** `gh repo create --private --source=. --push` for `modem-playing` and `temple`. The rest — copy the folder to an archive drive/bucket, or just let them go.

### 1b. Local-only branches in repos that DO have remotes

These branches were never pushed. The remote knows nothing about them.

**Top level (`~/development`):**

| Repo | Local-only branches |
|---|---|
| `euicc-toolkit` | `jfo/reconnect-issue` — 1 commit, **2026-08-10, three days ago**: "fix: t-1 vs t-0 connect/reconnect issue" |
| `ansible` | `jfo/dbup` (3, Dec 2025 — "feat!: new postgres 18 db_url"), `jfo/dbdupWRITE` (2), `jfo/22` (1) |
| `cron-jobs` | `jfo/archivejs` (6), `jfo/ts-utils-rabbit-cost` (2) |
| `onomondo-base` | `jfo/backoffice` (4), `jfo/connectors-submodules` (2), `jfo/fix-bin-app` (1 — "fix: setting working dir fixes path issues") |
| `esim-iot-base` | `jfo/integration` (2) |
| `terraform` | `jfo/signalling-rabbit` (1) |

**Inside submodules — this is the dangerous part.** `git status` in the parent repo does not show these.

| Submodule | Local-only branches |
|---|---|
| `esim-iot-base/eim` | **17 branches**, incl. `jfo/c/tests2` (13 commits), `jfo/c/ref` (7), `ai/refactor` (5), `jfo/refactor-01` (3), `jfo/rm-unn-subdir-01` (3), plus 3 × `worktree-agent-*` at 11 commits each |
| `esim-iot-base/api` | 8 branches: `jfo/api/2-internal-state`, `3-org-gated-orders`, `4-housekeeping`, `5-internal-order-endpoints`, `6-docs`, `jfo/c/ref` (8), `jfo/c/init`, `docker-fix` |
| `onomondo-base/onomondo-signalling` | `jfo/chunks` (5), `jfo/worker-chunks` (4), + 6 more |
| `onomondo-base/onomondo-app` | `jfo/i18n` (7), `jfo/wiregasm` (3), `jfo/dev` (2), `design-system-extraction` |
| `onomondo-base/onomondo-migrations` | `jfo/backwards` (2), `jfo/qfix` (2), `jfo/detach` |
| `onomondo-base/onomondo-api` | `jfo/orm`, `jfo/context-orgs`, `jfo/iccid`, `jfo/sentry`, `jfo/npm`, `asdf` |
| `onomondo-base/onomondo-webhooks-v2` | `jfo/memcache`, `jfo/cache-move-2`, `jfo/asdf` |
| `esim-iot-base/dashboard` | `jfo/docker` |
| `esim-iot-base/app` | `jfo/c/init` |

**Suggested one-liner** — run per repo and per submodule, pushes every unpushed local branch to a namespace you can pick through later from the new machine:

```fish
for b in (git for-each-ref --format='%(refname:short)' refs/heads)
  git push origin $b:refs/heads/archive/old-mac/$b
end
```

(No `-u` — you don't want your local branches re-pointed at the archive refs.)

The `worktree-agent-*` and `fart` branches are almost certainly agent scratch — worth a look before you spend pushes on them.

### 1c. Stashes (32 total)

Stashes don't push. They die with the disk.

| Repo | Stashes |
|---|---|
| `onomondo-base/onomondo-api` | 5 |
| `onomondo-base/onomondo-signalling` | 4 |
| `onomondo-base/onomondo-webhooks-v2` | 4 |
| `code/dotfiles` | 3 (Apr 2026, Jan 2026, Oct 2025) |
| `onomondo-base/onomondo-migrations` | 3 |
| `onomondo-base/onomondo-app` | 2 |
| `development/timeseries-db` | 2 (Dec 2025, Nov 2025) |
| `development/onomondo-base` (parent) | 1 — "WIP on jfo/gs", Oct 2025 |
| `development/ansible` | 1 — "WIP on master: feat: scheduling cost alerts cron-jobs", Jun 2025 |
| `development/euicc-toolkit` | 1 — "WIP on master: feat: add enable/disable profile commands (ES10c)", Jul 2026 |
| `esim-iot-base/api`, `esim-iot-base/eim`, `esim-iot-base-old`, `lets-timeseries`, `test-postgres-partitioning`, `xs1-micro-sumo-robot` | 1 each |

Fastest triage: `git stash list` then `git stash show -p stash@{0}`. Anything you want to keep → `git stash branch keep/thing stash@{0}` and push it with the loop above.

### 1d. Dirty working trees worth a look

Ignoring the obvious noise (`package-lock.json`, README typos, the `linux` kernel clone):

- **`development/esim-iot-base`** on `jfo/eim-state-layer` — the big one. Staged additions (`.env.example`, `Dockerfile.api.dev`, `Dockerfile.app.dev`, `README.md`), modified `docker-compose.yml`, `e2e/README.md`, plus 4 submodule pointer moves. Plus `dashboard` has 6 modified `.tsx`/`.ts` files uncommitted (`App.tsx`, `api/eim.ts`, `ActionBar.tsx`, `Header.tsx`, `useFacilityResources.ts`, `types.ts`).
- **`development/lets-timeseries`** — staged `dupe_schema.sql` + `procedure.md`, and untracked `jfo-conn-strings` and `scratch.sql`.
- **`development/jeffs-db`** — modified `main.tf`, `modules/rds/main.tf`, `.terraform.lock.hcl`.
- **`development/growth-website-wordpress`** — 4 modified vendor JS files (probably build artifacts).
- **`code/exercises`** — 3 ziglings in progress (`035_enums.zig` … `037_structs.zig`) + 1 unpushed commit.
- **`code/alaina-thing`** — modified `backend/sessions.db` (a SQLite file; probably just runtime state).

### 1e. Loose non-git folders

Worth keeping (has data or unique scratch you can't regenerate):

- `development/network_removal` — 4 CSV backups of prod/test networks + the selection/deletion SQL. **This is prod data, decide deliberately.**
- `development/tofun` and `code/logical-replication` — contain `terraform.tfstate` + backups. Check these aren't tracking anything live before deleting.
- `development/notes` — 15 files of ops notes (acl, archive_dates, cdrs_v2_counts, hlroutage, pgdupe, replication…), last touched Sep 2025.
- `development/signalling-logs-dupe` — 130 files, last touched Jun 2026. Recent, and has `note`/`todo`/pcap.
- `development/sqldebug` — DMS support-collector output + HTML reports for prod/test schemas.
- `~/slop` — 5 markdown notes from Jul 2026 (eim-refactor, persistence point-counterpoint, skill-assessment) + `kobserve.fish` + `logview.mjs`. The two scripts look like keepers.
- `~/notes` — separate from `development/notes`, includes `onomondo-arch`, `post-mortem`, `survey`, `staff.txt`, `monies.js`.

Safe to drop: `development/debug`, `log_graph`, `logsshit`, `scripts`, `signalling-tests`, `sims_pagination_investigate`, `tech-day`, `ub`, `west-test` (regenerate with `west init`), `code/db-discussion` (a downloaded JDK + Derby source), `code/admin_panel`, `code/jeffcorp`, `code/mem-leak-repro` (empty), `code/fifo-queue`, `code/ind`.

### 1f. Housekeeping

- `esim-iot-base` has 3 **prunable** git worktrees under `.claude/worktrees/` (`crazy-aryabhata`, `eloquent-pare`, `strange-matsumoto`), all detached at `fd7f6d2`. `git worktree prune` before you archive anything.
- `~/old-config` is empty — 11 directories, one stray file (`nvim/fart`). Delete it, don't migrate it.
- `.ccls-cache/` directories are inflating untracked counts in `libsys` (1,646), `wiregasm` (1,476), `postgres` (328), `softsim` (188), `nrf-softsim` (103), `node-lksctp`, `chuck`. All regenerable. Worth adding `.ccls-cache` to your global gitignore — you already have `.ccls*` there, but the cache dir is escaping it in these repos.
- `~/node_modules` exists at the top of your home directory. Nothing good comes from that.

### 1g. The re-clone shortlist

Of 129 repos, 28 saw a commit in 2026. That's your natural cut line — clone these on demand and let the other 101 stay on GitHub where they already are.

**Work (`~/development`):** `euicc-toolkit` (Aug 10) · `esim-iot-base` (Aug 4) · `db` (Jul 29) · `shared-workflows` (Jun 19) · `repo-management` (Jun 19) · `ono-platform` (May 1) · `gitops-infra` (Apr 28) · `ono-app` (Apr 24) · `growth-website-wordpress` (Apr 21) · `growth-website-api` (Apr 21) · `onomondo-pgw` (Mar 18) · `onomondo-eim` (Mar 10) · `onomondo-base` (Feb 17) · `ansible` (Feb 10) · `osmo-ttcn3-hacks` (Feb 2) · `onomondo-traffic-storer` (Jan 29) · `osmo-dev` (Jan 7) · `terraform` (unpushed work) · `cron-jobs` (unpushed work)

**Personal (`~/code`):** `dotfiles` (Aug 9) · `blog` (Aug 4) · `pg-playground` (Aug 3) · `exercises` (Jun 5, ziglings in progress) · `ghostty` (Mar 17) · `fish-shell` (Jan 18) · `learn-you-some-erlang` (Jan 7) · `VVVVVV` (Mar 22) · `quizz` (9 unpushed gh-pages commits)

**Hardware/side:** `modem-playing` (Jan 22, no remote) · `xs1-micro-sumo-robot` (Feb 19, has a stash) · `esim-iot-base-old` (Jan 28 — probably retirable now that `esim-iot-base` exists; check `jfo-report.md` in it first)

Leave behind and re-clone only if needed: the upstream reading copies (`postgres`, `linux`, `v8`, `neovim`, `node`, `express`, `sequelize`, `knex`, `redis`/`ioredis`, `mongo`, `fish-shell`, `gleam`, `chuck`, `monome`, `sild`, `tock`, `zig-*`, `pg_partman`, `copilot.vim`, `sentry-javascript`, `JSONStream`, `opossum`, `amqplib`, `node-*`, `wiregasm`, `softsim`, `libsys`) — 60+ repos that are one `git clone` away and cost you nothing to abandon. Same for the 37 repos last touched in 2024 and earlier.

---

## 2. What to install

### 2a. Homebrew — the set worth installing

228 formulae are installed but only 80 are top-level (`brew leaves`); the rest are dependencies. The grouping below is the leaves plus the handful of things that are technically dependencies but that you clearly use directly (`zig`, `erlang`, `rebar3`, `pyenv`, `llvm@21`). Install these and Homebrew pulls in the other 148.

**Shell / core:** `fish` `stow` `tmux` `neovim` `git` `gh` `git-delta` `diff-so-fancy` `ripgrep` `the_silver_searcher` `bat` `jq` `yq` `tree` `htop` `wget` `parallel` `fswatch` `watchexec` `tokei` `glow` `pandoc` `terminal-notifier` `make` `automake` `cmake` `ninja` `ccache`

**Languages / runtimes:** `fnm` (node) · `asdf` + `kerl` + `rebar3` + `erlang-language-platform` (erlang) · `pyenv` `pyenv-virtualenv` `python@3.11` `uv` · `go` · `rustup` · `zig` `zls` · `emacs` `php` `composer`

**Cloud / infra:** `awscli` `terraform` `terraform-ls` `opentofu` `ansible` `ansible-lint` `ansible@10` `kubernetes-cli` `helm` `argocd` `stern` `k9s` `docker-credential-helper-ecr` `dive` `podman` `teller`

**Data:** `postgresql@14` `postgresql@16` `redis`

**C/embedded/hardware:** `ccls` `llvm@21` `lld@21` `dtc` `gperf` `west` `lsusb` `tio` `opensc` `nss` `wxwidgets` `nmap` `nginx`

**AI/LLM:** `llm` (+ plugins `llm-anthropic`, `llm-cmd`) · `ollama`

**Fun / niche:** `chuck` `serialosc` `rogue` `astroterm` `ffmpeg` `python-matplotlib` `cmark` `fop` `ansifilter` `gnupg`

**Taps needed:** `ddev/ddev` `derailed/k9s` `da-luce/astroterm` `ra3xdh/qucs-s` `anomalyco/tap` `homebrew/services`

**Casks (12):** `1password-cli` `font-hack` `chromium` `kitty` `codex` `wireshark` `wireshark-app` `arduino-ide` `nrfutil` `nordic-nrf-command-line-tools` `segger-jlink` `qucs-s`

> **Gotcha:** `brew bundle dump` on your machine omitted `k9s`, `ddev` and `astroterm` even though all three are installed and their taps are tapped. Don't trust the dump blindly — diff it against `brew list --formula` before you rely on it.

### 2b. Candidates to drop

- **`postgresql@14`** — you also have 16. Keep 16 unless something specifically needs 14.
- **`podman` + Docker Desktop + OrbStack** — three container runtimes. OrbStack is wired into your `config.fish`; Docker.app was used 2026-08-11. Pick two at most.
- **`emacs`** — you're a neovim user. Possibly a dependency of something you forgot.
- **`ansible@10` alongside `ansible`** — version pin you may not need any more.
- **`iTerm` + `kitty` + `Ghostty`** — Ghostty is your daily driver (used today); the other two haven't been opened.
- **`rogue`** — no judgement, just noting it.
- **144 outdated formulae** — the clean install fixes that for free.

### 2c. Not from Homebrew

| Thing | How |
|---|---|
| Node versions | **33 fnm versions installed** (v14.8 → v26.5). Install `v25.6.1` (your default) + maybe latest LTS. Don't recreate the rest. |
| npm globals | Only `onomondo-live@4.0.9`. |
| Go binaries | `github.com/unknwon/bra`, `github.com/evilmartians/lefthook` |
| Cargo | `bpf-linker` v0.9.14 |
| pip | `pypdf` (user install) |
| asdf plugins | `erlang 28.3.1`, `java adoptopenjdk-jre-24.0.2+12`, `rebar 3.24.0` (all in your tracked `.tool-versions`) — plus `opencode 1.2.6` and `python 3.14.4` which are **installed but not in `.tool-versions`** |
| pyenv | `3.7.17` installed, version set to `system`. Probably droppable. |
| Zephyr SDK | `~/zephyr-sdk-0.17.4` + `~/nrf` + `~/.nrfutil` + `~/.nrfconnect-apps` — reinstall via nRF Connect rather than copying |
| Claude Code | `~/.local/bin/claude` |
| aider | `~/.local/bin/aider` |
| ghostty-navigator.nvim | `~/.local/bin/ghostty-navigator.nvim` — built binary, needs rebuilding (your `init.vim` loads the plugin with `RestartDK/ghostty-navigator.nvim`) |
| tpm | `git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm` then `<prefix>+I` (documented in your `tmux.conf`) |
| vim-plug | `make plug` in dotfiles handles it |
| fzf | Installed by the vim-plug `junegunn/fzf` entry into `~/.fzf` |

---

## 3. Applications

### Bring — actively used (last-opened date from Spotlight)

| App | Last used | Install route |
|---|---|---|
| Slack | today | direct / MDM |
| Ghostty | today | direct (your daily terminal) |
| Claude | today | direct |
| TablePlus | 2026-08-12 | direct, **licence key needed** |
| Firefox | 2026-08-12 | direct |
| Wireshark | 2026-08-11 | `brew --cask wireshark-app` |
| Google Chrome | 2026-08-11 | direct |
| Docker Desktop | 2026-08-11 | direct |
| Spotify | 2026-08-10 | direct |
| 1Password | 2026-08-10 | direct + `1password-cli`. **Do this first** — everything else needs it |
| Tailscale | 2026-07-30 | direct. Your `config.fish` puts `/Applications/Tailscale.app/Contents/MacOS` on PATH, and you have a kube context through it |
| Ollama | 2026-07-29 | app + `brew ollama` |
| Gitify | 2026-07-29 | direct |
| UniFi Endpoint | 2026-07-27 | direct |
| Rectangle | 2026-07-27 | direct (in your README already) |
| Obsidian | 2026-07-06 | direct — **vault must come across, see §4** |
| nRF Connect for Desktop | 2026-06-26 | direct |
| Cursor | 2026-06-24 | direct |
| UTM | 2026-06-18 | direct |

### Company-managed — let IT push these, don't hand-install

`Company Portal`, `Huntress`, `Microsoft Teams`, `ExpressVPN`

### Leave behind (never opened on this machine, per Spotlight)

`Arc` · `Visual Studio Code` (but keep the extension list below) · `Codex` (you have the cask) · `ChatGPT` · `Notion` (web works) · `iTerm` · `kitty` · `Chromium` · `OpenCode` · `NoSQL Workbench` · `RDM` · `Raspberry Pi Imager` · `Blender` · `BambuStudio` · `Autodesk Fusion` (in `~/Applications`) · `Qucs-S` · `Arduino IDE` · `Keymapp` · `Logi Options` · `VMware Fusion` (you have UTM + OrbStack) · `zoom.us` · `Safari`/`GarageBand`/`iMovie`/`Keynote`/`Pages`/`Numbers` (ship with macOS) · `Google Docs/Sheets/Slides` (Chrome PWAs, recreate if wanted) · `1Password 7.app.zip` (a zip sitting in `/Applications` — just noise) · `OrbStack` **only if** you decide against it; it's referenced in `config.fish`

Reinstall on demand rather than up front: BambuStudio, Blender, Fusion, Arduino IDE, Qucs-S, Keymapp. These are project-specific and you'll know when you need them.

### VS Code / Cursor extensions (if you set either up again)

`asvetliakov.vscode-neovim` · `github.copilot-chat` · `ms-azuretools.vscode-containers` · `ms-azuretools.vscode-docker` · `ms-vscode-remote.remote-containers` · `ms-vscode.cpptools` · `nordic-semiconductor.nrf-connect` / `nrf-devicetree` / `nrf-kconfig` / `nrf-terminal` · `trond-snekvik.gnu-mapfiles` · `twxs.cmake`

The Nordic set is the reason VS Code is on the machine at all — nRF Connect drives it.

---

## 4. Not in git anywhere — manual checklist

Nothing below is recoverable from a repo. Move it deliberately or lose it.

**Credentials & keys**

- [ ] `~/.ssh/` — 4 keypairs: `id_ed25519` (`jfo@Jeff.local`), `onomondo` (`jf@onomondo.com`), `codeberg`, `dingus`, plus `agent`, `cp`, `known_hosts`. **Better: generate new keys on the new machine** and re-register with GitHub/Codeberg/Onomondo, rather than copying private keys around. Faster than it sounds and leaves the old key retirable.
- [ ] `~/.ssh/config` — host blocks for `*`, `*.public *.ext *.aws *.ibm *.onomondo.io`, `github.com`, `codeberg.org`, `dingus` (→ `dingus.local`). **Not in dotfiles. Worth adding** (it has no secrets, only hostnames).
- [ ] `~/.aws/config` — `[sso-session jfo-ono]`, `[default]`, `[profile esim-iot-staging]`, `[573010787783_ReadOnlyAccess]`
- [ ] `~/.aws/credentials` — `[jfo-dev]`, `[jfo-prod-readonly]` — long-lived keys. Rotate rather than copy.
- [ ] `~/.config/fish/secrets.fish` — 3 vars: `ADVENT_OF_CODE_TOKEN`, `CLAUDE_API_KEY`, `OBSIDIAN_VAULT_PATH`. Gitignored by `*secret*` in your dotfiles `.gitignore`, correctly. Put these in 1Password now.
- [ ] `~/.npmrc`, `~/.yarnrc` — may hold registry tokens
- [ ] `~/.erlang.cookie`
- [ ] `~/.gnupg` — was empty until my script ran (it created the trustdb). No secret keys. Nothing to move.
- [ ] `gh auth login` — re-auth on the new box
- [ ] `~/.terraform.d/` — credentials / plugin cache
- [ ] `~/.docker/`, `~/.kube/` — kube context `staging-esim-iot-euc1` + `production-euc1-tailscale-operator...ts.net`. Both regenerable via `aws eks update-kubeconfig` and Tailscale.

**Data**

- [ ] **Obsidian vault** — `$OBSIDIAN_VAULT_PATH` in `secrets.fish`. Your `init.vim` has `<leader>D` daily-note and `<leader>T` global-todo bindings that depend on it. Find out where it lives; if it's not already in iCloud or a git repo, that's a single point of failure worth fixing during the move.
- [ ] `~/notes` and `development/notes` and `~/slop` — three separate note piles. Good moment to consolidate into the vault.
- [ ] `~/.psql_history`, `~/.node_repl_history`, `~/.atsh_history` — probably not, but the psql one sometimes has a query you want
- [ ] `~/.local/state/theme` — one line, your `tt` light/dark state. Regenerates.
- [ ] `~/Virtual Machines.localized` (VMware) and `~/OrbStack` — VM images. Large. Rebuild rather than copy unless a VM holds state you need.
- [ ] `~/QucsWorkspace` — circuit sims, if any matter
- [ ] `~/.claude.json` + `~/.claude/` — Claude Code project history/state. `.claude/settings.json` and `CLAUDE.md` are stowed from dotfiles; the rest is local history.

**Not checked** — my inventory script's last few sections got cut off. If you want them:

```
{ du -sh ~/* | sort -rh | head -30
  ls ~/Library/LaunchAgents /Library/LaunchAgents
  crontab -l
  defaults read -g InitialKeyRepeat; defaults read -g KeyRepeat; } 2>&1
```

LaunchAgents and crontab matter if you have background jobs you've forgotten about.

---

## 5. Dotfiles gaps

Your repo currently stows 9 things (`.gitconfig`, `.gitconfig-work`, `.gitignore`, `.tool-versions`, `.asdfrc`, `.tmux.conf`, `.claude/settings.json`, `.claude/CLAUDE.md`, plus the `.config/` tree for fish/nvim/ghostty). The `makefile` does `stow` → `plug` → `last`. That part is solid.

What's missing, roughly in order of how much it'll annoy you on day one:

**1. No Brewfile.** The README lists ~15 programs by hand; you actually have 91 top-level formulae, 12 casks and 6 taps. You already bookmarked [Matthias Portzel's brewfile post](https://matthiasportzel.com/brewfile/) in the TODO. Do it:

```
brew bundle dump --file=Brewfile --describe --force
```

Then `brew bundle install` becomes one step. Note `brew bundle dump` also captures `vscode`, `go`, `cargo` and `npm` entries, which covers four of the gaps below for free.

**2. Three untracked fish function files.** `~/.config/fish/functions/` has `fish_prompt.fish`, `fish_user_key_bindings.fish` and `tt.fish` — none in the repo. Your README says "Didn't need the fish functions folder in here, must run `fish_config`" — but that's exactly why your prompt won't come across. Add `dots/.config/fish/functions/`.

Also: `tt` is defined **twice** — as a function in `config.fish` *and* as `functions/tt.fish`. The function file wins. Worth resolving before you copy the confusion to a new machine.

**3. No `~/.ssh/config`.** Hostnames only, no secrets. Add `dots/dot-ssh/config` (stow with `--dotfiles` handles the rename) or a `ssh-config` file the bootstrap symlinks.

**4. asdf drift.** `.tool-versions` has erlang/java/rebar, but `opencode 1.2.6` and `python 3.14.4` are installed as asdf plugins and not recorded. Either add them or accept they're ad-hoc.

**5. The manual steps in the README aren't executable.** The `defaults write` key-repeat lines, the caps→ctrl remap, hot corners, dock cleanup, invert scroll — all prose. A `macos.sh` with the `defaults write` calls turns 20 minutes of clicking into one command. Your existing two lines are the start:

```bash
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
```

**6. Post-stow steps aren't in `make all`.** tpm clone, `fish_config` for the vcs prompt, `llm install llm-anthropic llm-cmd`, `llm models default`, `fnm install`, `asdf plugin add`, `go install` × 2, `cargo install bpf-linker`, `npm i -g onomondo-live`, `rustup default stable`. These are scattered across the README as notes. A `make bootstrap` that runs them in order is the whole point of the exercise.

**7. README is stale.** It says `llm install llm-claude-3` and `llm models default claude-3.5-[sonnet|haiku]`; you're actually on `llm-anthropic` 0.17 with default `anthropic/claude-opus-4-0`. Also lists Table Plus / Rectangle / 1Password / Slack / Firefox / Chrome / Docker Desktop as prose — those belong in the Brewfile as casks or a "manual installs" list you can tick off.

**8. Three stashes and `.todo` sitting in the repo.** `stash@{0}` from Apr 2026, `{1}` Jan 2026, `{2}` Oct 2025. Look at them before the move; they're dotfiles changes you started and dropped.

**9. `.DS_Store` is untracked in the repo and `.gitignore` doesn't cover it** at repo level (your *global* gitignore does, but the repo's own `.gitignore` only has `*secret*` and `.git-blame-ignore-revs`). Trivial, but it shows up in every `git status`.

**10. `ghostty/config` has `command = /opt/homebrew/bin/fish` hardcoded** with a `# TODO: dynamic path here` next to it. Fine on another arm64 Mac; will silently break if the prefix ever differs.

Nice touch worth keeping: the comments in `config.fish` and `ghostty/config` warning not to edit stowed files in place because `perl -i` would sever the symlink. That's the kind of note that saves you an hour in a year.

---

## 6. Day-of runbook

**Before you wipe — on the old machine**

1. `brew bundle dump --file=~/code/dotfiles/Brewfile --describe --force`, commit, push.
2. Add the untracked fish functions + `.ssh/config` to dotfiles, commit, push. (§5.1–5.3)
3. Triage the 25 stashes (§1c). `git stash branch` anything you want, else let it go.
4. Run the archive-push loop over every repo *and every submodule* with local-only branches (§1b). Suggested wrapper:
   ```fish
   for d in ~/development/*/ ~/code/*/
     test -e $d/.git || continue
     pushd $d
     for b in (git for-each-ref --format='%(refname:short)' refs/heads)
       git push origin $b:refs/heads/archive/old-mac/$b 2>/dev/null
     end
     popd
   end
   ```
   Then repeat inside `esim-iot-base` and `onomondo-base` with `git submodule foreach`.
5. `gh repo create --private --source=. --push` for `modem-playing` and `temple`.
6. Copy the keep-list of loose folders (§1e) somewhere durable — `network_removal`, `notes`, `slop`, `signalling-logs-dupe`, `sqldebug`.
7. Locate and back up the Obsidian vault. Put `secrets.fish` values into 1Password.
8. Screenshot: System Settings you care about, Dock, hot corners, Rectangle shortcuts, Ghostty window layout. Cheaper than remembering.
9. `git status` sweep to confirm nothing new appeared:
   ```fish
   for d in ~/development/*/ ~/code/*/
     test -e $d/.git || continue
     set -l s (git -C $d status --porcelain | wc -l)
     test $s -gt 0 && echo "$d: $s"
   end
   ```

**On the new machine, in order**

1. macOS updates, then Apple ID / iCloud.
2. **1Password** first, then everything else can authenticate.
3. Xcode Command Line Tools: `xcode-select --install`
4. Homebrew.
5. `brew bundle install --file=Brewfile` — this is the long one, go make coffee.
6. `chsh -s /opt/homebrew/bin/fish` (add it to `/etc/shells` first).
7. SSH keys: generate new, add to GitHub + Codeberg + wherever Onomondo needs them. `ssh -T git@github.com` to confirm.
8. `git clone git@github.com:jfo/dotfiles ~/code/dotfiles && cd ~/code/dotfiles && make`
9. `make plug` runs automatically via `make all`; check nvim opens clean.
10. tpm clone + `<prefix>+I`. `fish_config` for the vcs prompt.
11. Restore `secrets.fish` from 1Password.
12. `fnm install 25.6.1 && fnm default 25.6.1`
13. asdf: `asdf plugin add erlang java rebar`, then `asdf install` (reads your `.tool-versions`).
14. `aws configure sso` → `jfo-ono`. Then `aws eks update-kubeconfig` for the staging cluster.
15. `gh auth login`
16. `llm install llm-anthropic llm-cmd` + `llm keys set anthropic` + `llm models default anthropic/claude-opus-4-0`
17. Claude Code, Tailscale, Docker/OrbStack.
18. macOS settings: key repeat, caps→ctrl, hot corners, scroll direction, dock. (Your keyboard firmware may cover caps→ctrl.)
19. Clone repos as you need them — **not all at once**. That's how the mess started.

**Verify**

- `nvim` opens with no plugin errors; `<leader>D` finds the vault
- `tt` toggles theme in Ghostty and nvim
- `git config user.email` → `jeffowler@gmail.com` in `~/code`, `jf@onomondo.com` in `~/development` (the `includeIf` on `gitdir:~/development/`)
- `aws sts get-caller-identity`, `kubectl get ns`
- Push a trivial dotfiles commit end to end

---

## Appendix

`repo-audit.csv` — all 152 entries with branch, last activity, dirty/untracked counts, stash count, unpushed branches and remote. Sort by `stashes` or `unpushed_branches` to work the triage list.

The audit covered top-level directories in `~/development` and `~/code` plus submodules of `esim-iot-base` and `onomondo-base`. Submodules of other repos, and any nested repos deeper than one level, weren't walked — worth a spot check if you have a repo-of-repos I didn't spot.
