# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
# source /etc/bash_gitprompt;
# source /etc/bash_gitcompletion;

source ~/.aliases;

PATH=$PATH:$HOME/bin;
