export EDITOR=vi
export VISUAL=vi

if [ -r ~/.bash_prompt ]; then 
    . ~/.bash_prompt
fi

if [ -r ~/.bash_profile.local ]; then 
    . ~/.bash_profile.local
fi

PATH="$HOME/bin:$PATH"

alias less='less -R'
