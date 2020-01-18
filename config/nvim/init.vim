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

    call plug#begin()
    Plug 'pangloss/vim-javascript'
    Plug 'scrooloose/syntastic'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'mattn/emmet-vim'
    Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
    Plug 'leafOfTree/vim-svelte-plugin'
    Plug 'ciaranm/detectindent'
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    call plug#end()

    set winheight=40
    set cmdheight=3
    " set list listchars=tab:\ \ ,trail:·
    set laststatus=2
    set autoread
    set mouse=

    colorscheme challenger_deep

    let g:syntastic_check_on_open = 1
    let g:syntastic_javascript_checkers = [ 'eslint' ]
    let g:syntastic_php_phpcs_args="--standard=PSR1"
    let g:syntastic_php_checkers = ['php' ]

    let g:javascript_plugin_jsdoc = 1
    let g:vue_pre_processors = []

    au VimEnter * set winheight=3
    au WinEnter * set winheight=999
    au VimEnter * set winminheight=3

    autocmd BufNewFile,BufRead *.js set foldmethod=indent foldlevel=3
    autocmd BufNewFile,BufRead *.sql set foldmethod=indent foldlevel=3
    autocmd BufNewFile,BufRead *.txt set textwidth=76 noautoindent nocindent
    autocmd BufNewFile,BufRead *.hjs set filetype=mustache
    autocmd BufNewFile,BufRead *.hbs set filetype=mustache
    autocmd BufNewFile,BufRead *.mmm set filetype=mustache
    autocmd BufNewFile,BufRead *.vue set filetype=vue
    autocmd BufNewFile,BufRead *.svelte set filetype=svelte
    "autocmd BufWritePost *.js silent ![ -x ./node_modules/.bin/esformatter ] && ./node_modules/.bin/esformatter % -i
    autocmd BufReadPost * DetectIndent

    augroup javascript_folding
        au!
        au FileType javascript setlocal foldmethod=syntax
    augroup END


endif

" Force ourselves to use home-row motion keybindings
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

set secure
