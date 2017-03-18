# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	source /etc/bashrc
fi

# User specific aliases and functions

source /etc/bash_gitprompt
source /etc/bash_gitcompletion
source ~/.aliases

alias vi='vim'

PATH=$PATH:$HOME/bin:$HOME/development/bin/DevTools

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="$PATH:$HOME/.rvm/bin"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
