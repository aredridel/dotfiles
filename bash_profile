if which vise 2> /dev/null > /dev/null; then
    export EDITOR=vise
    export VISUAL=vise
fi

PS1="\w\n;: "

. ~/.iterm2_shell_integration.bash

shopt -s checkhash
shopt -s cmdhist
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -s lithist
shopt -s no_empty_cmd_completion

alias less='less -R'

MANPATH=man:/usr/local/share/man:/usr/share/man
export MANPATH

if which brew >/dev/null 2>&1; then
    PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
fi

PATH="$PATH:$HOME/.cargo/bin"

if which npx >/dev/null 2>&1; then
    source <(npx --shell-auto-fallback)
fi

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
    . ~/.nix-profile/etc/profile.d/nix.sh
fi

if [ -d ~/System ]; then
    PATH=~/System/bin:"$PATH"
    MABPATH=~/System/share/man:"$MANPATH"
fi

if [ -d ~/.local/bin ]; then
    PATH=~/.local/bin:"$PATH"
fi

if [ -d ~/.composer/vendor/bin ]; then
    export PATH=~/.composer/vendor/bin:"$PATH"
fi

#export NIX_PATH=nixpkgs=~/Projects/nixpkgs

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

if [ -d /usr/local/plan9 ]; then
    export PLAN9=/usr/local/plan9
    PATH=$PATH:$PLAN9/bin
fi

export PATH=node_modules/.bin:$HOME/bin:$PATH

alias wow="git status"
alias such=git
alias very=git
alias please=sudo

if which nvim 2>/dev/null >/dev/null; then
    alias vim=nvim
    alias vi=nvim
elif which vim 2>/dev/null >/dev/null; then
    alias vi=vim
fi

if which starship 2> /dev/null >/dev/null; then
    eval "$(starship init bash)"
fi

if which powerline-go 2> /dev/null >/dev/null; then
    function _update_ps1() {
        PS1="$(powerline-go -error $?)"
    }

    PROMPT_COMMAND="_update_ps1"
fi

if [ -d ~/.cargo/bin ]; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -r ~/.bash_profile.local ]; then 
    . ~/.bash_profile.local
fi

