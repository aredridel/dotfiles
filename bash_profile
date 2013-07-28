export EDITOR=vi
export VISUAL=vi


if [ -r ~/.bash_prompt ]; then 
    . ~/.bash_prompt
fi

if [ -r ~/.bash_profile.local ]; then 
    . ~/.bash_profile.local
fi

if which vim >/dev/null 2>&1; then
    alias vi=vim
fi

alias less='less -R'

if which brew >/dev/null 2>&1; then
    PATH="/usr/local/bin:/usr/local/sbin:$PATH"

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi

    if brew --prefix josegonzalez/php/php54 >/dev/null; then
        PATH="$(brew --prefix josegonzalez/php/php54)/bin:$PATH"
    fi
fi

if [ -d ~/Library/Perl/5/lib/perl5/ ]; then
    eval $(perl -I ~/Library/Perl/5/lib/perl5/ -Mlocal::lib)
fi

export PLAN9=/usr/local/plan9
PATH=$PATH:$PLAN9/bin
export PATH=$HOME/bin:/usr/local/share/npm/bin:$PATH:node_modules/.bin/
