set -gx EDITOR nvim
set -gx FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git -g ""'
set -gx HOMEBREW_NO_INSTALL_CLEANUP 1
set -x BAT_THEME "gruvbox-dark"

alias tl="tmux list-sessions"
alias ta="tmux attach"
alias nvimo="nvim -S ~/.vim/sessions/last.vim"

# still works but would like something more interesting here, project idea?
alias serve='python3 -m http.server 80'

# alias killswap='rm ~/.local/share/nvim/swap/*'
alias killswap='echo \'Killswap is broken, if you need it, fix it properly.\''

alias udate='date +%s'
alias cat='bat'

# TODO: pull these into their own function files, why not?
function clone
  git clone git@github.com:$argv[1]
end

function psq
  $VIM_RUNNERS_SQL_COMMAND $argv[1]
end

function gits
    git submodule foreach --quiet 'echo $path' | parallel --will-cite "cd {} && $argv"
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

if test -f ~/.config/fish/theme-functions.fish
  source ~/.config/fish/theme-functions.tfish
end

set -e fish_user_paths

fish_add_path /usr/local/bin
fish_add_path /Users/jfo/.fzf/bin
fish_add_path /Users/jfo/code/zig/build/stage3/bin
fish_add_path /Users/jfo/code/zls/zig-out/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

fzf --fish | source

fnm env --log-level=quiet --use-on-cd | source

set fish_color_cwd grey
set fish_greeting
bind \cp fzf-file-widget

# TODO: move to a function file?
function produce_ccls
  echo 'zig cc' > .ccls
  set capture 0
  zig cc -E -x c - -v < /dev/null 2>&1 | \

  while read -l line
    if string match -q '*#include <...>*' $line
      set capture 1
      continue
    else if string match -q '*End of search list*' $line
      set capture 0
      continue
    end

    if test $capture -eq 1
      echo "-isystem"(string trim $line) >> .ccls
    end
  end
end

source ~/.orbstack/shell/init2.fish 2>/dev/null || :
