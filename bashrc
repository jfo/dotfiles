source ~/.aliases

export PATH="$PATH:$HOME/dogfood/bin"
export PATH="$PATH:$HOME/go/bin"

#rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
export PATH="$PATH:$HOME/.rvm/bin"

#fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[\033[34m\]\w\[\033[95m\]\$(parse_git_branch)\[\033[00m\] $ "


