export EDITOR=vi
export VISUAL=vi

export PATH=$PATH:node_modules/.bin/

if [ -r ~/.bash_prompt ]; then 
    . ~/.bash_prompt
fi

if [ -r ~/.bash_profile.local ]; then 
    . ~/.bash_profile.local
fi

PATH="$HOME/bin:$PATH"

if which vim >/dev/null 2>&1; then
    alias vi=vim
fi

alias less='less -R'

if which -s brew; then
    PATH="/usr/local/bin:/usr/local/sbin:$PATH"

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi

    if brew --prefix josegonzalez/php/php54 >/dev/null; then
        PATH="$(brew --prefix josegonzalez/php/php54)/bin:$PATH"
    fi
fi
