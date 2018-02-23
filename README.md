# Dotfiles for days

TODO: write about dotfiles

## a little bit about mac setup:

reset the caps lock key to control.
remove everything from dock and autohide it
autohide the menu bar
turn off siri

spectacles
iterm2

key repeat rate:
    defaults read | grep Repeat
    defaults write -g InitialKeyRepeat -int 15
    defaults write -g KeyRepeat -int 1

set up desktop hot corner

homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install tmux
brew install neovim
brew install fzf
~/.vim/plugged/fzf/install | yes

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git clone http://github.com/jfo/dotfiles
rake link

mkdir ~/.vim/sessions/

TODO:
fix path and make environments different
move to src folder and use a single `make link` rule to symlink all things
set up personal git credentials to commit this stuff.
