set -gx EDITOR nvim
set -gx FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git -g ""'
set -gx HOMEBREW_NO_INSTALL_CLEANUP 1

alias pt="papertrail"
alias tl="tmux list-sessions"
alias ta="tmux attach"
alias nvimo="nvim -S ~/.vim/sessions/last.vim"
alias serve='python -m SimpleHTTPServer 80'
alias killswap='rm ~/.local/share/nvim/swap/*'
alias udate='date +%s'

function clone
  git clone git@github.com:$argv[1]
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
