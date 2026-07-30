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
   set -l title "Annoy"
   set -l message "your ish is done"
   set -l args $argv

   if test (count $argv) -ge 2
     if test "$argv[1]" = "--title" -o "$argv[1]" = "-t"
       set title "$argv[2]"
       if test (count $argv) -ge 3
         set args $argv[3..-1]
       else
         set args
       end
     end
   end

   if test (count $args) -gt 0
     set message (string join " " $args)
   end

   if type -q terminal-notifier
     terminal-notifier -title "$title" -message "$message" -sender "com.apple.Terminal"
   else
     osascript -e "display notification \"$message\""
   end
end

if test -f ~/.config/fish/secrets.fish
  source ~/.config/fish/secrets.fish
end

set -e fish_user_paths

fish_add_path $HOME/.local/bin \
    $HOME/code/zig-bootstrap/out/build-zig-host/stage3/bin \
    /opt/homebrew/bin \
    /opt/homebrew/sbin \
    $HOME/.fzf/bin \
    /Applications/Tailscale.app/Contents/MacOS \
    /usr/local/bin

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

function tt --description "Toggle light/dark theme for ghostty and neovim"
    # Never edit the stowed config files themselves: they are symlinks into the
    # dotfiles repo, and an in-place rewrite (perl -i) replaces the symlink with
    # a regular file, silently severing the repo from the live config. Write
    # only these two untracked files instead.
    set -l state ~/.local/state/theme
    set -l ghostty_theme ~/.config/ghostty/theme.conf

    set -l current dark
    if test -r $state
        set current (string trim <$state)
    end

    set -l bg light
    if test "$current" = light
        set bg dark
    end

    mkdir -p (dirname $state) (dirname $ghostty_theme)
    echo $bg >$state

    # ghostty has no runtime theme API; it re-reads its config on SIGUSR2.
    if test "$bg" = light
        echo "theme = Gruvbox Material Light" >$ghostty_theme
    else
        echo "theme = Gruvbox Material Dark" >$ghostty_theme
    end
    killall -USR2 ghostty

    for socket in (lsof -c nvim -a -U 2>/dev/null | awk 'NR>1{print $NF}' | grep '^/')
        nvim --server $socket --remote-send ":set background=$bg<CR>" 2>/dev/null
    end
end
