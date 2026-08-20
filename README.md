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
| `make claude-app` | copy the portable half of CLAUDE.md to the clipboard |


Installed outside brew, handled by `bootstrap.sh`:

- node via `fnm` (25.6.1 + LTS)
- erlang / java / rebar via `asdf`, pinned in `dot-tool-versions`

Not scripted — install by hand when you need them:

1Password · Ghostty · Slack · Firefox · Chrome · TablePlus (licence key) ·
Rectangle · Tailscale · Docker Desktop or OrbStack · Obsidian · Claude ·
Gitify · Spotify · nRF Connect for Desktop · UTM

Originally based on [maximum awesome](https://developer.squareup.com/blog/fly-vim-first-class/),
_so many changes_ since then.

TODO
----
- better support for contexts, more than just gitconf
- make fish prompt better
- modernize vim config and packages being used
  - snippets
  - omnicomplete
  - linting / prettier / zig fmt, etc
- [zvm](https://github.com/tristanisham/zvm) or similar for zig versioning...
- `ghostty/config` hardcodes `command = /opt/homebrew/bin/fish`
