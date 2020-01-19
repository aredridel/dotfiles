source ~/.profile

if which brew >/dev/null 2>&1; then
    PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
fi

if which npx >/dev/null 2>&1; then
    source <(npx --shell-auto-fallback)
fi

source /usr/local/share/antigen/antigen.zsh
fpath=(/usr/local/share/zsh-completions $fpath)

antigen use oh-my-zsh

antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle softmoth/zsh-vim-mode

antigen theme robbyrussell

antigen apply

if which starship 2> /dev/null >/dev/null; then
	source <(starship init zsh --print-full-init)
fi

autoload -U compinit && compinit
fpath=(/usr/local/share/zsh-completions $fpath)

if which awless 2> /dev/null >/dev/null; then
	source <(awless completion zsh)
fi

#if which powerline-go 2> /dev/null >/dev/null; then
#	function powerline_precmd() {
#		PS1="$(powerline-go -error $? -shell zsh)"
#	}
#
#	function install_powerline_precmd() {
#		for s in "${precmd_functions[@]}"; do
#			if [ "$s" = "powerline_precmd" ]; then
#			return
#			fi
#		done
#		precmd_functions+=(powerline_precmd)
#	}
#
#	if [ "$TERM" != "linux" ]; then
#		install_powerline_precmd
#	fi
#fi
