export TIME_STYLE=long-iso
alias ll="exa -lh --git"

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

if [ -d ~/.cargo/bin ]; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

export PATH=node_modules/.bin:$HOME/bin:$PATH

if [ -r ~/.profile.local ]; then 
    . ~/.profile.local
fi
