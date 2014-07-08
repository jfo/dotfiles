# load our own completion functions
fpath=(~/.zsh/completion $fpath)

# completion
autoload -U compinit
compinit

# for function in ~/.zsh/functions/*; do
#   source $function
# done

# automatically enter directories without cd
setopt auto_cd

# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode
bindkey jj vi-cmd-mode

# use incremental search
bindkey "^R" history-incremental-search-backward

# add some readline keys back
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# handy keybindings
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

# expand functions in the prompt
setopt prompt_subst

# prompt
export PS1='[${SSH_CONNECTION+"%n@%m:"}%~] '

# ignore duplicate history entries
setopt histignoredups

# keep TONS of history
export HISTSIZE=4096

# look for ey config in project dirs
export EYRC=./.eyrc

# automatically pushd
setopt auto_pushd
export dirstacksize=5

# awesome cd movements from zshkit
setopt AUTOCD
setopt AUTOPUSHD PUSHDMINUS PUSHDSILENT PUSHDTOHOME
setopt cdablevars

# Try to correct command line spelling
# setopt CORRECT CORRECT_ALL


# Enable extended globbing
setopt EXTENDED_GLOB

# Allow [ or ] whereever you want
unsetopt nomatch

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

 # get the name of the branch we are on
 git_prompt_info() {
     git branch | awk '/^\*/ { print $2 }'
 }
 get_git_dirty() {
   git diff --quiet || echo '*'
 }

 autoload -U colors
 colors
 setopt prompt_subst

# Below from a prompt change for git branches inclusion.
# Initialize colors.
#
autoload -U colors
colors

# Allow for functions in the prompt.
setopt PROMPT_SUBST

# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)

# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

# Set the prompt.
PROMPT=$'[%{${fg[cyan]}%}%B%~%b]$(prompt_git_info)%{${fg[default]}%} '

export PYTHONPATH=/Users/jeff/code
export PATH=/Users/jeff/.rvm/gems/ruby-2.0.0-p353/bin:/Users/jeff/.rvm/gems/ruby-2.0.0-p353@global/bin:/Users/jeff/.rvm/rubies/ruby-2.0.0-p353/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/jeff/.rvm/bin:~/code/nand2tetris/tools:~/code/nand2tetris/compiler:/Users/jeff/bin/

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting


# if [[ ! $TERM =~ screen ]]; then
#     exec tmux
# fi
