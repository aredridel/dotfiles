" Spaces, not tabs.
set expandtab
set shiftwidth=4
set tabstop=4
set nohlsearch
set exrc
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
    syntax enable

    set winheight=40
    set cmdheight=3
    " set list listchars=tab:\ \ ,trail:·
    set laststatus=2
    set autoread
    set mouse=

    colorscheme desert

    let g:syntastic_check_on_open = 1
    let g:syntastic_javascript_checkers = [ 'eslint' ]
    let g:syntastic_php_phpcs_args="--standard=PSR1"
    let g:syntastic_php_checkers = ['php' ]

    au VimEnter * set winheight=3
    au WinEnter * set winheight=999
    au VimEnter * set winminheight=3

    autocmd BufNewFile,BufRead *.js set foldmethod=indent foldlevel=3
    autocmd BufNewFile,BufRead *.sql set foldmethod=indent foldlevel=3
    autocmd BufNewFile,BufRead *.txt set textwidth=76 noautoindent nocindent
    autocmd BufNewFile,BufRead *.hjs set syntax=mustache
    autocmd BufNewFile,BufRead *.hbs set syntax=mustache
    autocmd BufNewFile,BufRead *.mmm set syntax=mustache
    "autocmd BufWritePost *.js silent ![ -x ./node_modules/.bin/esformatter ] && ./node_modules/.bin/esformatter % -i
    autocmd BufReadPost * DetectIndent


    " Set up Vundle
    set rtp+=~/.vim/bundle/Vundle.vim/
    call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'vim-stylus'
    Plugin 'pangloss/vim-javascript'
    Plugin 'scrooloose/syntastic'
    Plugin 'tpope/vim-surround'
    Plugin 'tpope/vim-repeat'
    Plugin 'tpope/vim-commentary'
    Plugin 'ciaranm/detectindent.git'
    filetype plugin indent on
    call vundle#end()
endif

" Force ourselves to use home-row motion keybindings
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

set secure
