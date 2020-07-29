" Spaces, not tabs.  set expandtab
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
    set cmdheight=6
    " set list listchars=tab:\ \ ,trail:·
    set laststatus=2
    set autoread
    set mouse=nv

    let &t_ut=''

    " let g:typescript_indent_disable = 1

    " let g:coc_global_extensions = [ 'coc-prettier', 'coc-marketplace', 'coc-lists', 'coc-diagnostic', 'coc-git', 'coc-eslint', 'coc-emoji', 'coc-emmet', 'coc-browser', 'coc-tsserver', 'coc-svg', 'coc-svelte', 'coc-stylelintplus', 'coc-sh', 'coc-rust-analyzer', 'coc-markmap', 'coc-markdownlint', 'coc-json', 'coc-import-cost', 'coc-html', 'coc-deno', 'coc-css', 'coc-phpls' ]
    "
    let g:vdebug_keymap = {
    \    'run' : '<Leader>dr',
    \    'run_to_cursor' : '<Leader>dc',
    \    'step_over' : '<Leader>dn',
    \    'step_into' : '<Leader>di',
    \    'step_out' : '<Leader>do',
    \    'close' : '<Leader>dx',
    \    'detach' : '<Leader>dq',
    \    'set_breakpoint' : '<Leader>db',
    \    'get_context' : '<Leader>dg',
    \    'eval_under_cursor' : '<Leader>e',
    \    'eval_visual' : '<Leader>v'
    \}

    let g:javascript_plugin_jsdoc = 1

    " Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
    let g:vista#renderer#enable_icon = 1

    " The default icons can't be suitable for all the filetypes, you can extend it as you wish.
    let g:vista#renderer#icons = {
                \   "function": "\uf794",
                \   "variable": "\uf71b",
                \  }

    " Executive used when opening vista sidebar without specifying it.
    " See all the avaliable executives via `:echo g:vista#executives`.
    let g:vista_default_executive = 'coc'

    let g:blade_custom_directives = ['svelte', 'announcement']
    let g:blade_custom_directives_pairs = {
        \   'ifannouncement': 'endifannouncement',
        \ }

    call plug#begin()
    Plug 'vim-vdebug/vdebug'
    Plug 'liuchengxu/eleline.vim'
    Plug 'liuchengxu/vista.vim'
    Plug 'haya14busa/vim-edgemotion'
    Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
    " Plug 'vim-airline/vim-airline'
    " Plug 'prabirshrestha/async.vim'
    " Plug 'prabirshrestha/vim-lsp'
    " Plug 'mattn/vim-lsp-settings'
    " Plug 'prabirshrestha/asyncomplete.vim'
    " Plug 'prabirshrestha/asyncomplete-lsp.vim'
    " Plug 'ryanolsonx/vim-lsp-typescript'
    " Plug 'autozimu/LanguageClient-neovim', {
    "     \ 'branch': 'next',
    "     \ 'do': 'bash install.sh',
    "     \ }
    Plug 'pangloss/vim-javascript'
    Plug 'tpope/vim-surround'
    " Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'mattn/emmet-vim'
    Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
    Plug 'leafOfTree/vim-svelte-plugin'
    " Plug 'evanleck/vim-svelte'
    Plug 'ciaranm/detectindent'
    Plug 'leafgarland/typescript-vim'
    Plug 'udalov/kotlin-vim'
    Plug 'jwalton512/vim-blade'
    call plug#end()

    autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

    set completeopt=menu,menuone,preview,noselect,noinsert

    colorscheme challenger_deep

    au VimEnter * set winheight=3
    au WinEnter * set winheight=999
    au VimEnter * set winminheight=3

    autocmd BufNewFile,BufRead *.js set foldmethod=manual foldlevel=3
    autocmd BufNewFile,BufRead *.sql set foldmethod=indent foldlevel=3
    autocmd BufNewFile,BufRead *.txt set textwidth=76 noautoindent nocindent
    autocmd BufNewFile,BufRead *.kt set filetype=kotlin
    autocmd BufNewFile,BufRead *.hbs set filetype=html
    autocmd BufNewFile,BufRead *.svelte set filetype=svelte foldmethod=manual foldlevel=3 iskeyword=@,_,-,48-57
    autocmd BufNewFile,BufRead *.html set iskeyword=@,_,-,48-57
    autocmd BufNewFile,BufRead *.blade.php set iskeyword=@,_,-,48-57
    "autocmd BufWritePost *.js silent ![ -x ./node_modules/.bin/esformatter ] && ./node_modules/.bin/esformatter % -i
    autocmd BufReadPost * DetectIndent

    augroup javascript_folding
        au!
        au FileType javascript setlocal foldmethod=syntax
    augroup END

    set foldlevelstart=5
    "
    " Better display for messages
    set cmdheight=6

    " You will have bad experience for diagnostic messages when it's default 4000.
    set updatetime=500

    if 1 " has('coc.nvim')
        " coc config
        " if hidden is not set, TextEdit might fail.
        set hidden

        " Some servers have issues with backup files, see #649
        set nobackup
        set nowritebackup

        " don't give |ins-completion-menu| messages.
        set shortmess+=c

        " always show signcolumns
        set signcolumn=yes

        " Use tab for trigger completion with characters ahead and navigate.
        " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
        inoremap <silent><expr> <TAB>
                    \ pumvisible() ? "\<C-n>" :
                    \ <SID>check_back_space() ? "\<TAB>" :
                    \ coc#refresh()
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

        function! s:check_back_space() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        " Use <c-space> to trigger completion.
        inoremap <silent><expr> <c-space> coc#refresh()

        " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
        " Coc only does snippet and additional edit on confirm.
        inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
        " Or use `complete_info` if your vim support it, like:
        " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

        " Use `[g` and `]g` to navigate diagnostics
        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)

        " Remap keys for gotos
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)

        " Use K to show documentation in preview window
        nnoremap <silent> K :call <SID>show_documentation()<CR>

        function! s:show_documentation()
            if (index(['vim','help'], &filetype) >= 0)
                execute 'h '.expand('<cword>')
            else
                call CocAction('doHover')
            endif
        endfunction

        " Highlight symbol under cursor on CursorHold
        autocmd CursorHold * silent call CocActionAsync('highlight')

        " Remap for rename current word
        nmap <leader>rn <Plug>(coc-rename)

        " Remap for format selected region
        xmap <leader>f  <Plug>(coc-format-selected)
        nmap <leader>f  <Plug>(coc-format-selected)

        augroup mygroup
            autocmd!
            " Setup formatexpr specified filetype(s).
            autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
            " Update signature help on jump placeholder
            autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        augroup end

        " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
        xmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>a  <Plug>(coc-codeaction-selected)

        " Remap for do codeAction of current line
        nmap <leader>ac  <Plug>(coc-codeaction)
        " Fix autofix problem of current line
        nmap <leader>qf  <Plug>(coc-fix-current)

        " Create mappings for function text object, requires document symbols feature of languageserver.
        xmap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap if <Plug>(coc-funcobj-i)
        omap af <Plug>(coc-funcobj-a)

        " Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
        nmap <silent> <TAB> <Plug>(coc-range-select)
        xmap <silent> <TAB> <Plug>(coc-range-select)

        " Use `:Format` to format current buffer
        command! -nargs=0 Format :call CocAction('format')

        " Use `:Fold` to fold current buffer
        command! -nargs=? Fold :call     CocAction('fold', <f-args>)

        " use `:OR` for organize import of current buffer
        command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

        " Add status line support, for integration with other plugin, checkout `:h coc-status`
        set statusline^=%{coc#status()}%{get(b:,'vista_nearest_method_or_function','')}

        " Using CocList
        " Show all diagnostics
        nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
        " Manage extensions
        nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
        " Show commands
        nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
        " Find symbol of current document
        nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
        " Search workspace symbols
        nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
        " Do default action for next item.
        nnoremap <silent> <space>j  :<C-u>CocNext<CR>
        " Do default action for previous item.
        nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
        " Resume latest coc list
        nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

        "---------

        map <C-j> <Plug>(edgemotion-j)
        map <C-k> <Plug>(edgemotion-k)
    endif

    " Load all plugins now.
    " Plugins need to be added to runtimepath before helptags can be generated.
    packloadall
    " Load all of the helptags now, after plugins have been loaded.
    " All messages and errors will be ignored.
    silent! helptags ALL
endif

" Force ourselves to use home-row motion keybindings
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

set secure
