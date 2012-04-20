set expandtab
set shiftwidth=4
set tabstop=4

set nocompatible
set ruler

" Set autoindenting and handle doxygen style comments
set smarttab
set cindent
set formatoptions+=ro

call pathogen#infect() 

if has('syntax')
    let g:load_doxygen_syntax=1
    set winheight=40
    set cmdheight=3

    set list
    set lcs=tab:>-,nbsp:.,trail:.
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
        imap <expr> <Esc>[201~ XTermPasteEnd("")
        cmap <Esc>[200~ <nop>
        cmap <Esc>[201~ <nop>
    endif

    colorscheme molokai

    let g:Gitv_OpenHorizontal = 'auto'

    autocmd BufNewFile,BufRead $HOME/Projects/html5/* set tabstop=4 shiftwidth=4 noet
endif

set scrolloff=5
set shiftround
set backspace=indent

noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
