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
