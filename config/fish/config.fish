set -gx EDITOR nvim

alias tl="tmux list-sessions"
alias ta="tmux attach"
alias vim='nvim'
alias vimo="vim -S ~/.vim/sessions/last.vim"
alias serve='python -m SimpleHTTPServer 4321'
alias killswap='rm ~/.local/share/nvim/swap/*'
alias udate='date +%s'
alias clip='xclip -sel clip'
alias np='npm i --no-package-lock'
alias port="lsof -i tcp:$1"

function clone
  git clone git@github.com:$argv[1]
end

function biner
  ln -s (greadlink -f $argv[1]) ~/.bin
end

function unbiner
  rm ~/.bin/$argv[1]
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

if test -f ~/.config/fish/fish_secrets
  source ~/.config/fish/fish_secrets
end

xset r rate 250 60