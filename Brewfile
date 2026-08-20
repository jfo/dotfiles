tap "derailed/k9s"
tap "homebrew/services"

# ---------- shell, editor, terminal ----------
brew "fish"                       # login shell
brew "stow"                       # dotfile symlinking (this repo)
brew "neovim"

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
brew "glow"
brew "pandoc"
brew "cmark"
brew "ansifilter"
brew "fop"
brew "terminal-notifier"          # `annoy` function in config.fish

# ---------- build tooling ----------
brew "make"
brew "automake"
brew "cmake"
brew "ninja"
brew "ccache"
brew "gperf"
brew "dtc"
brew "ccls"                       # C/C++ LSP; see `produce_ccls` in config.fish
brew "tree-sitter"

# ---------- languages and runtimes ----------
brew "fnm"                        # node; `fnm env --use-on-cd` in config.fish
brew "asdf"                       # erlang/java/rebar via .tool-versions
brew "rebar3"
brew "erlang-language-platform"
brew "kerl"
brew "zig"
brew "zls"
brew "pyenv"
brew "pyenv-virtualenv"
brew "uv"

# ---------- cloud and infra ----------
brew "awscli"
brew "terraform"
brew "terraform-ls"
brew "opentofu"
brew "ansible"
brew "ansible-lint"
brew "kubernetes-cli"
brew "helm"
brew "argocd"
brew "stern"
brew "derailed/k9s/k9s"
brew "docker-credential-helper-ecr"
brew "dive"
brew "teller"

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

# ---------- casks ----------
cask "1password-cli"
cask "font-hack"                  # ghostty font-family
cask "wireshark-app"
cask "nrfutil"
cask "nordic-nrf-command-line-tools"
cask "segger-jlink"
cask "arduino-ide"
cask "qucs-s"
