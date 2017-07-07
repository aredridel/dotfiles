export EDITOR=vis
export VISUAL=vis


if [ -r ~/.bash_prompt ]; then 
    . ~/.bash_prompt
fi

if [ -r ~/.bash_profile.local ]; then 
    . ~/.bash_profile.local
fi

. ~/.iterm2_shell_integration.bash

shopt -s checkhash
shopt -s cmdhist
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -s lithist
shopt -s no_empty_cmd_completion

alias less='less -R'

if which brew >/dev/null 2>&1; then
    PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi

    if which -s android; then
        ANDROID_HOME="$(brew --prefix android)"
        PATH="${PATH}:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools"
        export ANDROID_HOME
    fi

fi

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
    . ~/.nix-profile/etc/profile.d/nix.sh
fi

if [ -d ~/.local/bin ]; then
    PATH=~/.local/bin:"$PATH"
fi

if [ -d ~/.composer/vendor/bin ]; then
    export PATH=~/.composer/vendor/bin:"$PATH"
fi

#export NIX_PATH=nixpkgs=~/Projects/nixpkgs

MANPATH=/usr/local/share/man:/usr/share/man
export MANPATH

if [ -d /usr/pkg/bin ]; then
    PATH="/usr/pkg/sbin:/usr/pkg/bin:$PATH"
    MANPATH="/usr/pkg/man:$MANPATH"
fi

if [ -d ~/Library/node/bin ]; then
    PATH=~/Library/node/bin:"$PATH"
fi

if [ -d ~/Library/Perl/5/lib/perl5/ ]; then
    eval $(perl -I ~/Library/Perl/5/lib/perl5/ -Mlocal::lib)
fi

MANPATH="man:$MANPATH"

export PLAN9=/usr/local/plan9
PATH=$PATH:$PLAN9/bin
export PATH=node_modules/.bin:$HOME/bin:/usr/local/share/npm/bin:$PATH

export MANTA_URL=https://us-east.manta.joyent.com
export MANTA_USER=aredridel
export MANTA_KEY_ID=$(ssh-keygen -l -f $HOME/.ssh/id_rsa.pub | awk '{print $2}')
export SDC_URL=https://us-east-1.api.joyentcloud.com
export SDC_ACCOUNT=aredridel
export SDC_KEY_ID=$(ssh-keygen -l -f $HOME/.ssh/id_rsa.pub | awk '{print $2}')

alias wow="git status"
alias such=git
alias very=git

if which nvim 2>/dev/null >/dev/null; then
    alias vim=nvim
    alias vi=nvim
elif which vim 2>/dev/null >/dev/null; then
    alias vi=vim
fi
