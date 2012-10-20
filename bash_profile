export EDITOR=vi
export VISUAL=vi

if [ -r ~/.bash_prompt ]; then 
    . ~/.bash_prompt
fi

if [ -r ~/.bash_profile.local ]; then 
    . ~/.bash_profile.local
fi

alias less='less -R'

# {{{
# Node Completion - Auto-generated, do not touch.
shopt -s progcomp
for f in $(command ls ~/.node-completion); do
  f="$HOME/.node-completion/$f"
  test -f "$f" && . "$f"
done
# }}}
