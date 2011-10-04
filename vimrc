set ts=4
set et
set sw=4
set si

set nocompatible
set ruler

if has('syntax')
	filetype plugin indent on
	syntax enable


	if &term =~ "xterm.*"
		 let &t_ti = &t_ti . "\e[?2004h"
		 let &t_te = "\e[?2004l" . &t_te
		 function XTermPasteBegin(ret)
			  set pastetoggle=<Esc>[201~
			  set paste
			  return a:ret
		 endfunction
		 map <expr> <Esc>[200~ XTermPasteBegin("i")
		 imap <expr> <Esc>[200~ XTermPasteBegin("")
	endif

	colorscheme desert
endif

call pathogen#infect() 

