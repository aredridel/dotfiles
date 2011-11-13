set ts=4
set et
set sw=4
set si

set nocompatible
set ruler

if has('syntax')
    set winheight=40
    set ch=3
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
        function XTermPasteEnd(ret)
            set nopaste
            return a:ret
        endfunction
        map <expr> <Esc>[200~ XTermPasteBegin("i")
        imap <expr> <Esc>[200~ XTermPasteBegin("")
"        imap <expr> <Esc>[201~ XTermPasteEnd("")
        cmap <Esc>[200~ <nop>
        cmap <Esc>[201~ <nop>
    endif

    colorscheme desert
endif

call pathogen#infect() 

set so=5
