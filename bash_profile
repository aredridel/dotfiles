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

shopt -s checkhash
shopt -s cmdhist
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -s lithist
shopt -s no_empty_cmd_completion

alias less='less -R'

if which brew >/dev/null 2>&1; then
    PATH="/usr/local/bin:/usr/local/sbin:$PATH"

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
fi

if [ -d ~/Library/Perl/5/lib/perl5/ ]; then
    eval $(perl -I ~/Library/Perl/5/lib/perl5/ -Mlocal::lib)
fi

export PLAN9=/usr/local/plan9
PATH=$PATH:$PLAN9/bin
export PATH=$HOME/bin:/usr/local/share/npm/bin:$PATH:node_modules/.bin

export MANTA_URL=https://us-east.manta.joyent.com
export MANTA_USER=aredridel
export MANTA_KEY_ID=$(ssh-keygen -l -f $HOME/.ssh/id_rsa.pub | awk '{print $2}')
export SDC_URL=https://us-east-1.api.joyentcloud.com
export SDC_ACCOUNT=aredridel
export SDC_KEY_ID=$(ssh-keygen -l -f $HOME/.ssh/id_rsa.pub | awk '{print $2}')

alias wow="git status"
alias such=git
alias very=git
alias node="NODE_NO_READLINE=1 rlwrap -p green node"

function pleasedont {
    R=("can u not" "ಠ_ಠ" "(╯°□°）╯︵ ┻━┻")
    s=$(($RANDOM % ${#R[@]}))
    echo ${R[$s]}>&2
    return 1
}

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
    . ~/.nix-profile/etc/profile.d/nix.sh
fi
