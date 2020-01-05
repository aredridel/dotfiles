source ~/.profile

if which brew >/dev/null 2>&1; then
    PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
fi

if which npx >/dev/null 2>&1; then
    source <(npx --shell-auto-fallback)
fi

if which starship 2> /dev/null >/dev/null; then
	source <(starship init zsh --print-full-init)
fi

autoload -U compinit && compinit
fpath=(/usr/local/share/zsh-completions $fpath)
