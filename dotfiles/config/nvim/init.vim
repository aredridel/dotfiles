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
    set mouse=nv

    " let g:typescript_indent_disable = 1

    let g:coc_global_extensions = [ 'coc-prettier', 'coc-marketplace', 'coc-lists', 'coc-diagnostic', 'coc-git', 'coc-eslint', 'coc-emoji', 'coc-emmet', 'coc-browser', 'coc-tsserver', 'coc-svg', 'coc-svelte', 'coc-stylelintplus', 'coc-sh', 'coc-rls', 'coc-markmap', 'coc-markdownlint', 'coc-json', 'coc-import-cost', 'coc-html', 'coc-deno', 'coc-css', 'coc-phpls' ]

    let g:ale_open_list = 1
    " let g:ale_set_loclist = 0
    " let g:ale_set_quickfix = 1
    let g:ale_completion_enabled = 1
    let g:ale_use_global_executables = 1
    let g:ale_completion_tsserver_autoimport = 1

    let g:javascript_plugin_jsdoc = 1

    let g:ale_fixers = {
        \   '*': ['remove_trailing_lines', 'trim_whitespace'],
        \   'json': ['prettier'],
        \   'svelte': ['prettier'],
        \}

    call plug#begin()
    Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
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
    Plug 'ciaranm/detectindent'
    Plug 'vim-airline/vim-airline'
    Plug 'leafgarland/typescript-vim'
    Plug 'udalov/kotlin-vim'
    " Plug 'dense-analysis/ale'
    call plug#end()
 
    if has('ale')
        call ale#linter#Define('svelte', {
            \   'name': 'svelteserver',
            \   'lsp': 'stdio',
            \   'executable': 'svelteserver',
            \   'command': '%e --stdio',
            \   'project_root': '.',
            \})
        inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
        inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
    endif

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

    if has('languagelient-neovim')

        " lc
        let g:LanguageClient_serverCommands = {
            \ 'svelte': ['svelteserver', '--stdio'],
            \ 'javascript': ['typescript-language-server', '--stdio'],
            \ 'typescript': ['typescript-language-server', '--stdio'],
            \ 'php': ['intelephense', '--stdio'],
            \ 'json': ['vscode-json-languageserver', '--stdio'],
            \ }

        function LC_maps()
        if has_key(g:LanguageClient_serverCommands, &filetype)
            nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>
            nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
            nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
        endif
        endfunction

        set completefunc=LanguageClient#complete
        set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
        " let g:LanguageClient_selectionUI="quickfix"

        autocmd FileType * call LC_maps()
    endif

    if has('vim-lsp')
        " vim-lsp
        let g:lsp_virtual_text_enabled = 0
        let g:lsp_diagnostics_echo_cursor = 1
        set foldmethod=expr
            \ foldexpr=lsp#ui#vim#folding#foldexpr()
            \ foldtext=lsp#ui#vim#folding#foldtext()

        let g:lsp_log_file = expand('~/vim-lsp.log')

        function! s:on_lsp_buffer_enabled() abort
            setlocal omnifunc=lsp#complete
            nmap <buffer> gd <plug>(lsp-definition)
            nmap <buffer> gy <plug>(lsp-type-definition)
            nmap <buffer> gi <plug>(lsp-implementation)
            nmap <buffer> <leader>rn <plug>(lsp-rename)
            nmap <buffer> <leader>d <plug>(lsp-peek-definition)
            nmap <buffer> <leader>y <plug>(lsp-peek-type-definition)
            nmap <buffer> <leader>i <plug>(lsp-peek-implementation)
            nmap <buffer> <leader>h <plug>(lsp-type-hierarchy)
            nmap <buffer> ]g <plug>(lsp-next-diagnostic)
            nmap <buffer> [g <plug>(lsp-previous-diagnostic)
            nmap <buffer> ]e <plug>(lsp-next-error)
            nmap <buffer> [e <plug>(lsp-previous-error)
            nmap <buffer> ]w <plug>(lsp-next-warning)
            nmap <buffer> [w <plug>(lsp-previous-warning)
            " refer to doc to add more commands
        endfunction

        augroup lsp_install
            au!
            " call s:on_lsp_buffer_enabled only for languages that has the server registered.
            autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
        augroup END

        if executable('svelteserver')
            au User lsp_setup call lsp#register_server({
                \ 'name': 'svelteserver',
                \ 'cmd': { server_info->[&shell, &shellcmdflag, 'tee /Users/aria/in.log | svelteserver --stdio | tee /Users/aria/fffff.log']},
                \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
                \ 'whitelist': ['svelte']
                \ })
        endif

        inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
        inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
        imap <c-space> <Plug>(asyncomplete_force_refresh)
        set completeopt+=preview
        autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
    endif

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
        set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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
