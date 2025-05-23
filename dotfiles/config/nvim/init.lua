vim.g.javascript_plugin_jsdoc = 1
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

vim.opt.winheight = 40

require("config.lazy")

vim.cmd([[
    set expandtab " Spaces, not tabs.
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

    set noerrorbells "This removes vim's default error bell, turning it off so that it doesn't annoy us
    set cmdheight=4
    set laststatus=2
    set autoread

    set completeopt=menu,menuone,preview,noselect,noinsert

    colorscheme challenger_deep

    autocmd BufNewFile,BufRead *.js set foldmethod=manual foldlevel=3
    autocmd BufNewFile,BufRead *.sql set foldmethod=indent foldlevel=3
    autocmd BufNewFile,BufRead *.txt set textwidth=76 noautoindent nocindent
    autocmd BufNewFile,BufRead *.kt set filetype=kotlin
    autocmd BufNewFile,BufRead *.nix set filetype=nix
    autocmd BufNewFile,BufRead *.hbs set filetype=html
    autocmd BufNewFile,BufRead *.svelte set filetype=svelte foldmethod=manual foldlevel=3 iskeyword=@,_,-,48-57
    autocmd BufNewFile,BufRead *.html set iskeyword=@,_,-,48-57
    autocmd BufNewFile,BufRead *.blade.php set iskeyword=@,_,-,48-57

"    function! Prose()
"        let g:textobj#quote#educate = 1
"        let g:textobj#quote#matchit = 1
"        let g:pencil#conceallevel = 3
"        let g:pencil#concealcursor = 'c'
"        call pencil#init()
"        call textobj#quote#init({'educate': 1})
"        set nocindent smartindent linebreak spell backspace=indent,eol,start showbreak=+++
"        DittoOn  " Turn on Ditto's autocmds
"
"        nmap <leader>di <Plug>ToggleDitto      " Turn Ditto on and off
"        nmap =d <Plug>DittoNext                " Jump to the next word
"        nmap -d <Plug>DittoPrev                " Jump to the previous word
"        nmap +d <Plug>DittoGood                " Ignore the word under the cursor
"        nmap _d <Plug>DittoBad                 " Stop ignoring the word under the cursor
"        nmap ]d <Plug>DittoMore                " Show the next matches
"        nmap [d <Plug>DittoLess                " Show the previous matches
"
"    endfunction

"    autocmd FileType markdown,mkd,text call Prose()
"    command! -nargs=0 Prose call Prose()

    "autocmd BufWritePost *.js silent ![ -x ./node_modules/.bin/esformatter ] && ./node_modules/.bin/esformatter % -i
    autocmd BufReadPost * DetectIndent

    augroup javascript_folding
        au!
        au FileType javascript setlocal foldmethod=syntax
    augroup END

    set foldlevelstart=3

    " You will have bad experience for diagnostic messages when it's default 4000.
    set updatetime=500

    " Some servers have issues with backup files, see #649
    set nobackup
    set nowritebackup

    " don't give |ins-completion-menu| messages.
    set shortmess+=c

    " always show signcolumns
    set signcolumn=yes

    map <C-j> <Plug>(edgemotion-j)
    map <C-k> <Plug>(edgemotion-k)

    " Load all plugins now.
    " Plugins need to be added to runtimepath before helptags can be generated.
    packloadall
    " Load all of the helptags now, after plugins have been loaded.
    " All messages and errors will be ignored.
    silent! helptags ALL

    " Force ourselves to use home-row motion keybindings
    noremap <Up> <nop>
    noremap <Down> <nop>
    noremap <Left> <nop>
    noremap <Right> <nop>

    set secure

    aunmenu PopUp
    autocmd! nvim.popupmenu
]])
require("oil").setup()

vim.api.nvim_set_keymap('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d]', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
-- The following command requires plug-ins "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", and optionally "kyazdani42/nvim-web-devicons" for icon support
-- vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>', { noremap = true, silent = true })
-- If you don't want to use the telescope plug-in but still want to see all the errors/warnings, comment out the telescope line and uncomment this:
vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })
