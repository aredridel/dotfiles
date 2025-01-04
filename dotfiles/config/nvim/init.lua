vim.g.javascript_plugin_jsdoc = 1
local Plug = vim.fn['plug#']
vim.call('plug#begin')
Plug 'neovim/nvim-lspconfig'
Plug 'elixir-editors/vim-elixir'
Plug 'haya14busa/vim-edgemotion'
Plug 'stevearc/oil.nvim'
Plug 'tpope/vim-markdown'
Plug 'jceb/vim-orgmode'
Plug 'kylechui/nvim-surround'
Plug 'preservim/vim-pencil'
Plug 'dbmrq/vim-ditto'
Plug 'kana/vim-textobj-user'
Plug 'preservim/vim-textobj-quote'
Plug 'preservim/vim-textobj-sentence'
Plug 'tommcdo/vim-exchange'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-commentary'
Plug 'mattn/emmet-vim'
Plug('challenger-deep-theme/vim', {as = 'challenger-deep' })
Plug 'evanleck/vim-svelte'
Plug 'ciaranm/detectindent'
Plug 'leafgarland/typescript-vim'
Plug 'udalov/kotlin-vim'
Plug 'jwalton512/vim-blade'
Plug 'vim-crystal/vim-crystal'
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
-- Plug 'nvim-lua/plenary.nvim'
-- Plug 'nvim-telescope/telescope.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
vim.call('plug#end')

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
    set winheight=40
    set cmdheight=4
    set laststatus=2
    set autoread

    set completeopt=menu,menuone,preview,noselect,noinsert

    colorscheme challenger_deep

    au VimEnter * set winheight=3
    au VimEnter * set winminheight=3

    autocmd BufNewFile,BufRead *.js set foldmethod=manual foldlevel=3
    autocmd BufNewFile,BufRead *.sql set foldmethod=indent foldlevel=3
    autocmd BufNewFile,BufRead *.txt set textwidth=76 noautoindent nocindent
    autocmd BufNewFile,BufRead *.kt set filetype=kotlin
    autocmd BufNewFile,BufRead *.nix set filetype=nix
    autocmd BufNewFile,BufRead *.hbs set filetype=html
    autocmd BufNewFile,BufRead *.svelte set filetype=svelte foldmethod=manual foldlevel=3 iskeyword=@,_,-,48-57
    autocmd BufNewFile,BufRead *.html set iskeyword=@,_,-,48-57
    autocmd BufNewFile,BufRead *.blade.php set iskeyword=@,_,-,48-57

    function! Prose()
        let g:textobj#quote#educate = 1
        let g:textobj#quote#matchit = 1
        let g:pencil#conceallevel = 3
        let g:pencil#concealcursor = 'c'
        call pencil#init()
        call textobj#quote#init({'educate': 1})
        set nocindent smartindent linebreak spell backspace=indent,eol,start showbreak=+++
        DittoOn  " Turn on Ditto's autocmds

        nmap <leader>di <Plug>ToggleDitto      " Turn Ditto on and off
        nmap =d <Plug>DittoNext                " Jump to the next word
        nmap -d <Plug>DittoPrev                " Jump to the previous word
        nmap +d <Plug>DittoGood                " Ignore the word under the cursor
        nmap _d <Plug>DittoBad                 " Stop ignoring the word under the cursor
        nmap ]d <Plug>DittoMore                " Show the next matches
        nmap [d <Plug>DittoLess                " Show the previous matches

    endfunction

    autocmd FileType markdown,mkd,text call Prose()
    command! -nargs=0 Prose call Prose()

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
]])

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Set up lspconfig.
local lsp = require'lspconfig'
lsp.rust_analyzer.setup{
    capabilities = capabilities
}
lsp.lua_ls.setup{
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = {"vim"}
            }
        }
    }
}

lsp.harper_ls.setup {
    capabilities = capabilities,
    settings = {
        ["harper-ls"] = {
        }
    },
}

require("oil").setup()
