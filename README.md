# Dotfiles for days

Fresh machine, in order:

```
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone git@github.com:jfo/dotfiles ~/code/dotfiles && cd ~/code/dotfiles
./bootstrap.sh          # brew bundle, shell, stow, plug, tpm, node, erlang, llm, checks
./macos.sh              # system defaults
```

Install 1Password first if you have nothing else — everything below needs to
authenticate against something.

Targets
-------
| | |
|---|---|
| `make` | stow + vim-plug + session file (the old default) |
| `make stow` / `make clean` | symlink `dots/` into `$HOME`, or unlink |
| `make bootstrap` | full fresh-machine setup, `./bootstrap.sh <step>` for one step |
| `make macos` | system defaults: key repeat, dock, hot corners, finder |
| `make brewfile` | regenerate `Brewfile.new` from what's installed |
| `make adopt` | **run on the old machine** — pull untracked live config into the repo |
| `make claude-app` | copy the portable half of CLAUDE.md to the clipboard |

Never edit the stowed files in `$HOME` directly — they are symlinks into this
repo, and an in-place rewrite (`perl -i`, some editors' atomic save) replaces the
symlink with a regular file and silently severs the two.

What's tracked
--------------
`dots/` is stowed with `--dotfiles --no-folding`, so `dot-foo` becomes `~/.foo`
and directories are created rather than symlinked.

- `dot-gitconfig` + `dot-gitconfig-work` — work identity applies via
  `includeIf gitdir:~/development/`, so anything under `~/development` commits as
  `jf@onomondo.com` and everything else as `jeffowler@gmail.com`
- `dot-gitignore`, `dot-tmux.conf`, `dot-asdfrc`, `dot-tool-versions`
- `.config/fish/` — `config.fish` and `functions/`
- `.config/nvim/` — `init.vim` + `init-post.lua`
- `.config/ghostty/config`
- `.claude/` — `settings.json` and `CLAUDE.md`

Not tracked, on purpose
-----------------------
- `~/.config/fish/secrets.fish` — gitignored by `*secret*`. Holds
  `ADVENT_OF_CODE_TOKEN`, `CLAUDE_API_KEY`, `OBSIDIAN_VAULT_PATH`. Keep a copy in
  1Password; `bootstrap.sh` will tell you if it's missing.
- `~/.ssh/` keys — generate new ones per machine rather than copying them around.
  `dots/dot-ssh/config` (hostnames only) is tracked once you've run `make adopt`.
- `~/.aws/credentials`, `~/.kube/config` — regenerate with `aws configure sso`
  and `aws eks update-kubeconfig`.
- `~/.config/ghostty/theme.conf` — written by the `tt` function to toggle
  light/dark. Loaded last via `config-file = ?theme.conf`, so it overrides the
  default theme when present.

Software
--------
`Brewfile` is the source of truth for CLI tools and casks — 80 top-level
formulae, 11 casks, 6 taps as of Aug 2026. `brew bundle dump` has been observed
to silently drop tapped formulae (it missed `k9s`, `ddev` and `astroterm`), so
diff before you commit a regenerated one.

Installed outside brew, handled by `bootstrap.sh`:

- node via `fnm` (25.6.1 + LTS)
- erlang / java / rebar via `asdf`, pinned in `dot-tool-versions`
- `llm` plugins: `llm-anthropic`, `llm-cmd`; default model `anthropic/claude-opus-4-0`
- go: `bra`, `lefthook` · cargo: `bpf-linker` · npm: `onomondo-live`
- tpm for tmux, then `<prefix>+I`
- `fish_config` once, for the informative vcs prompt and fzf key bindings

Not scripted — install by hand when you need them:

1Password · Ghostty · Slack · Firefox · Chrome · TablePlus (licence key) ·
Rectangle · Tailscale · Docker Desktop or OrbStack · Obsidian · Claude ·
Gitify · Spotify · nRF Connect for Desktop · UTM

Company-managed, let IT push them: Company Portal, Huntress, Teams, ExpressVPN.

Originally based on [maximum awesome](https://developer.squareup.com/blog/fly-vim-first-class/),
so many changes since then.

TODO
----
- better support for contexts, more than just gitconf
- make fish prompt better
- modernize vim config and packages being used
  - snippets
  - omnicomplete
  - linting / prettier / zig fmt, etc
- [zvm](https://github.com/tristanisham/zvm) or similar for zig versioning...
- `tt` is defined twice — as a function in `config.fish` and as
  `functions/tt.fish`. The function file wins. Pick one.
- `ghostty/config` hardcodes `command = /opt/homebrew/bin/fish`
