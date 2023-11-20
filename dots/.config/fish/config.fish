set -gx EDITOR nvim
set -gx FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git -g ""'
set -gx HOMEBREW_NO_INSTALL_CLEANUP 1

alias pt="papertrail"
alias tl="tmux list-sessions"
alias ta="tmux attach"
alias nvimo="nvim -S ~/.vim/sessions/last.vim"
alias serve='python3 -m http.server 80'
alias killswap='rm ~/.local/share/nvim/swap/*'
alias udate='date +%s'
alias python='python3'
alias pip='pip3'

function clone
  git clone git@github.com:$argv[1]
end

function gits
  git submodule foreach $argv
end

function mkcd
  mkdir "$argv[1]" && cd "$argv[1]"
end

function listener
  lsof -nP -i4TCP:$argv[1] | grep LISTEN
end

function annoy
   osascript -e 'display notification "your ish is done"'
end

if test -f ~/.config/fish/secrets.fish
  source ~/.config/fish/secrets.fish
end

set -e fish_user_paths
set -U fish_user_paths ~/.npm-packages/bin

set -Ux BUN_INSTALL "~/.bun"
fish_add_path "~/.bun/bin"

fish_add_path /usr/local/opt/ruby/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /usr/local/bin
fish_add_path /Users/jfo/.fzf/bin
fish_add_path /Users/jfo/code/zig/build/stage3/bin
fish_add_path /Users/jfo/code/zls/zig-out/bin
fish_add_path /Users/jfo/code/depot_tools

set -gx PATH "/Users/jfo/Library/Caches/fnm_multishells/11624_1699281808366/bin" $PATH;
set -gx FNM_ARCH "arm64";
set -gx FNM_LOGLEVEL "info";
set -gx FNM_VERSION_FILE_STRATEGY "local";
set -gx FNM_RESOLVE_ENGINES "false";
set -gx FNM_MULTISHELL_PATH "/Users/jfo/Library/Caches/fnm_multishells/11624_1699281808366";
set -gx FNM_DIR "/Users/jfo/Library/Application Support/fnm";
set -gx FNM_NODE_DIST_MIRROR "https://nodejs.org/dist";
set -gx FNM_COREPACK_ENABLED "false";
