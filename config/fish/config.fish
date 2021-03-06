function fish_greeting
  set -l toon (random choice {default,bud-frogs,dragon,dragon-and-cow,elephant,moose,stegosaurus,tux,vader})
  fortune -s | cowsay -f $toon | lolcat
end

set -gx EDITOR nvim
set -gx FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git -g ""'

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

set -e fish_user_paths
set -U fish_user_paths ~/.npm-packages/bin
set -Ua fish_user_paths /usr/local/opt/postgresql@11/bin

set -gx PATH "/var/folders/3v/ym1h81wd45s3h94lfgvyqp9m0000gn/T/fnm_multishell_48166_1609755215663/bin" $PATH;
set -gx FNM_MULTISHELL_PATH "/var/folders/3v/ym1h81wd45s3h94lfgvyqp9m0000gn/T/fnm_multishell_48166_1609755215663";
set -gx FNM_DIR "/Users/jeff/.fnm";
set -gx FNM_LOGLEVEL "info";
set -gx FNM_NODE_DIST_MIRROR "https://nodejs.org/dist";
function _fnm_autoload_hook --on-variable PWD --description 'Change Node version on directory change'
    status --is-command-substitution; and return
    if test -f .node-version -o -f .nvmrc
        fnm use
    end
end
