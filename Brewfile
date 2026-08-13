# Generated from the old machine (2026-08-13) via `brew bundle dump --describe`,
# then hand-sorted and pruned. Install with:
#
#   brew bundle install --file=Brewfile
#
# `brew bundle dump` silently omitted k9s, ddev and astroterm on the old box even
# though all three were installed. They are added back by hand below. If you
# regenerate this file, diff it against `brew list --formula` before trusting it.

tap "anomalyco/tap"
tap "da-luce/astroterm"
tap "ddev/ddev"
tap "derailed/k9s"
tap "homebrew/services"
tap "ra3xdh/qucs-s"

# ---------- shell, editor, terminal ----------
brew "fish"                       # login shell
brew "stow"                       # dotfile symlinking (this repo)
brew "tmux"
brew "neovim"
brew "ncurses"

# ---------- git ----------
brew "git"
brew "gh"
brew "git-delta"
brew "diff-so-fancy"              # gitconfig pager + interactive.diffFilter

# ---------- search, files, text ----------
brew "ripgrep"
brew "the_silver_searcher"        # FZF_DEFAULT_COMMAND uses `ag`
brew "bat"                        # aliased to `cat` in config.fish
brew "jq"
brew "yq"
brew "tree"
brew "htop"
brew "wget"
brew "parallel"                   # `gits` function in config.fish
brew "fswatch"
brew "watchexec"
brew "tokei"
brew "glow"
brew "pandoc"
brew "cmark"
brew "ansifilter"
brew "fop"
brew "terminal-notifier"          # `annoy` function in config.fish
brew "gnupg"

# ---------- build tooling ----------
brew "make"
brew "automake"
brew "cmake"
brew "ninja"
brew "ccache"
brew "gperf"
brew "dtc"
brew "llvm@21"
brew "lld@21"
brew "ccls"                       # C/C++ LSP; see `produce_ccls` in config.fish
brew "tree-sitter"

# ---------- languages and runtimes ----------
brew "fnm"                        # node; `fnm env --use-on-cd` in config.fish
brew "asdf"                       # erlang/java/rebar via .tool-versions
brew "erlang", link: false
brew "rebar3"
brew "erlang-language-platform"
brew "kerl"
brew "go"
brew "rustup"
brew "zig"
brew "zls"
brew "pyenv"
brew "pyenv-virtualenv"
brew "python@3.11", link: false
brew "python@3.12", link: false
brew "uv"
brew "python-matplotlib"
brew "php"                        # ddev / wordpress work
brew "composer"
brew "emacs"                      # NOTE: you never open this. Delete the line if you agree.

# ---------- cloud and infra ----------
brew "awscli"
brew "terraform"
brew "terraform-ls"
brew "opentofu"
brew "ansible"
brew "ansible-lint"
brew "ansible@10", link: true     # NOTE: version pin. Drop if nothing needs 10.
brew "kubernetes-cli"
brew "helm"
brew "argocd"
brew "stern"
brew "derailed/k9s/k9s"
brew "docker-credential-helper-ecr"
brew "dive"
brew "podman"                     # NOTE: you also run Docker Desktop + OrbStack. Pick two.
brew "teller"
brew "ddev/ddev/ddev"

# ---------- data ----------
brew "postgresql@16"
brew "redis"
# brew "postgresql@14"            # left out on purpose. Uncomment if something needs 14.

# ---------- network, embedded, hardware ----------
brew "west"                       # zephyr meta-tool
brew "tio"
brew "lsusb"
brew "opensc"
brew "nss"
brew "nmap"
brew "nginx"
brew "wxwidgets"
brew "openssl@3"
brew "zstd"

# ---------- llm ----------
brew "llm"                        # plugins installed by bootstrap.sh
brew "ollama"

# ---------- media, fun, misc ----------
brew "ffmpeg"
brew "chuck"
brew "serialosc", restart_service: :changed
brew "rogue"
brew "da-luce/astroterm/astroterm"

# ---------- casks ----------
cask "1password-cli"
cask "font-hack"                  # ghostty font-family
cask "wireshark-app"
cask "nrfutil"
cask "nordic-nrf-command-line-tools"
cask "segger-jlink"
cask "arduino-ide"
cask "qucs-s"
cask "chromium"
cask "codex"
# cask "kitty"                    # left out: never opened on the old machine

# ---------- editor extensions (only if you install VS Code / Cursor) ----------
# The Nordic set is the only reason VS Code was on the old machine.
vscode "asvetliakov.vscode-neovim"
vscode "github.copilot-chat"
vscode "ms-azuretools.vscode-containers"
vscode "ms-azuretools.vscode-docker"
vscode "ms-vscode-remote.remote-containers"
vscode "ms-vscode.cpptools"
vscode "nordic-semiconductor.nrf-connect"
vscode "nordic-semiconductor.nrf-devicetree"
vscode "nordic-semiconductor.nrf-kconfig"
vscode "nordic-semiconductor.nrf-terminal"
vscode "trond-snekvik.gnu-mapfiles"
vscode "twxs.cmake"
