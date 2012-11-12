export EDITOR=vi
export VISUAL=vi

export PATH=$PATH:node_modules/.bin/

if [ -r ~/.bash_prompt ]; then 
    . ~/.bash_prompt
fi

if [ -r ~/.bash_profile.local ]; then 
    . ~/.bash_profile.local
fi

alias less='less -R'
