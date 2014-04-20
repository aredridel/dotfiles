" Spaces, not tabs.
set expandtab
set shiftwidth=4
set tabstop=4
set nohlsearch

set nocompatible
set ruler

" Keep lines on screen
set scrolloff=5

set shiftround

" Set autoindenting and handle doxygen style comments
set smarttab
set cindent
set backspace=indent
set formatoptions+=ro

if has('syntax')
    call pathogen#infect() 
    let g:load_doxygen_syntax=1
    let g:sql_type_default="mysql"
    set winheight=40
    set cmdheight=3
    set list listchars=tab:\ \ ,trail:·
    set laststatus=2

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

        if &term =~ "xterm-265.*"
            set t_AB=<Esc>[48;5;%dm
            set t_AF=<Esc>[38;5;%dm
        endif
    endif

    "colorscheme molokai
    colorscheme desert

    let g:Gitv_OpenHorizontal = 'auto'
    let g:syntastic_php_phpcs_args = '--standard=PSR1'
:
    autocmd BufNewFile,BufRead $HOME/Projects/html5/* set tabstop=4 shiftwidth=4 noexpandtab
    autocmd BufNewFile,BufRead xliff.csv set noexpandtab
    autocmd BufNewFile,BufRead *.yml set tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js set foldmethod=indent foldlevel=3
    autocmd BufNewFile,BufRead *.sql set foldmethod=indent foldlevel=3
    autocmd BufNewFile,BufRead *.txt set textwidth=76 noautoindent nocindent
    autocmd BufNewFile,BufRead *.us set syntax=html
    autocmd BufNewFile,BufRead *.hjs set syntax=mustache
    autocmd BufNewFile,BufRead *.mmm set syntax=mustache
    autocmd BufNewFile,BufRead *.coffee set ts=2 sw=2

    syntax enable
    function HtmlEscape()
        silent s/&/\&amp;/eg
        silent s/</\&lt;/eg
        silent s/>/\&gt;/eg
    endfunction

    function HtmlUnEscape()
        silent s/&lt;/</eg
        silent s/&gt;/>/eg
        silent s/&amp;/\&/eg
    endfunction

    autocmd BufNewFile,BufRead *.html nnoremap <Leader>h :call HtmlEscape()<CR>
    autocmd BufNewFile,BufRead *.html nnoremap <Leader>H :call HtmlUnEscape()<CR>

    autocmd BufNewFile,BufRead *.js nnoremap <Leader>j :%!js-beautify -f - --good-parts -j -k -s 4<CR>

    " Set up Vundle
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

    Plugin 'gmarik/vundle'

    Plugin 'tpope/vim-classpath'
    Plugin 'tlib'
    Plugin 'trag'
    Plugin 'molokai'
    Plugin 'vim-stylus'
    Plugin 'pangloss/vim-javascript'
    Plugin 'rodjek/vim-puppet'
endif

" Force ourselves to use home-row motion keybindings
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

