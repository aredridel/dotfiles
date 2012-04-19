" trag.vim -- Jump to a file registered in your tags
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-29.
" @Last Change: 2012-03-08.
" @Revision:    615
" GetLatestVimScripts: 2033 1 trag.vim

if &cp || exists("loaded_trag")
    finish
endif
if !exists('g:loaded_tlib') || g:loaded_tlib < 37
    runtime plugin/02tlib.vim
    if !exists('g:loaded_tlib') || g:loaded_tlib < 37
        echoerr 'tlib >= 0.37 is required'
        finish
    endif
endif
let loaded_trag = 10

let s:save_cpo = &cpo
set cpo&vim


" :nodoc:
TLet g:trag_kinds = {}
" :nodoc:
TLet g:trag_keyword_chars = {}


" :display: :TRagDefKind KIND FILETYPE /REGEXP_FORMAT/
" The regexp argument is no real regexp but a format string. % thus have 
" to be escaped with % (see |printf()| for details). The REGEXP_FORMAT 
" should contain at least one %s.
" Examples: >
"   TRagDefKind v * /\C\<%s\>\s*=[^=~<>]/
"   TRagDefKind v ruby /\C\<%s\>\(\s*,\s*[[:alnum:]_@$]\+\s*\)*\s*=[^=~<>]/
command! -nargs=1 TRagDefKind call trag#TRagDefKind(<q-args>)


" :display: TRagKeyword FILETYPE KEYWORD_CHARS
" Override 'iskeyword' for a certain filetype. See also |trag#CWord()|.
command! -nargs=+ TRagKeyword if len([<f-args>]) == 2
            \ | let g:trag_keyword_chars[[<f-args>][0]] = [<f-args>][1]
            \ | else
                \ | echoerr 'Expected "FILETYPE KEYWORDRX", but got: <q-args>'
                \ | endif


" :display: TRagDefFiletype FILETYPE EXTENSION ... FILENAME ...
" In order to recognize files based on their extension, you have to 
" declare filetypes first.
" If a file has no extension, the whole filename is used.
" On systems where the case of the filename doesn't matter (check :echo 
" has('fname_case')), EXTENSION should be defined in lower case letters.
" Examples: >
"   TRagDefFiletype html html htm xhtml
command! -nargs=+ TRagDefFiletype for e in [<f-args>][1:-1] | call trag#SetFiletype([<f-args>][0], e) | endfor


" :display: :TRag[!] KIND [REGEXP]
" Run |:TRagsearch| and instantly display the result with |:TRagcw|.
" See |trag#Grep()| for help on the arguments.
" If the kind rx doesn't contain %s (e.g. todo), you can skip the 
" regexp.
"
" Examples: >
"     " Find any matches
"     TRag . foo
" 
"     " Find variable definitions (word on the left-hand): foo = 1
"     TRag l foo
" 
"     " Find variable __or__ function/method definitions
"     TRag d,l foo
" 
"     " Find function calls like: foo(a, b)
"     TRag f foo
"
"     " Find TODO markers
"     TRag todo
command! -nargs=1 -bang -bar TRag TRagsearch<bang> <args> | TRagcw
command! -nargs=1 -bang -bar Trag TRag<bang> <args>


" :display: :TRagfile
" Edit a file registered in your tag files.
command! TRagfile call trag#Edit()
command! Tragfile call trag#Edit()


" :display: :TRagcw
" Display a quick fix list using |tlib#input#ListD()|.
command! -bang -nargs=? TRagcw call trag#QuickListMaybe(!empty("<bang>"))
command! -bang -nargs=? Tragcw call trag#QuickListMaybe(!empty("<bang>"))

" :display: :Traglw
" Display a |location-list| using |tlib#input#ListD()|.
command! -nargs=? Traglw call trag#LocList()


" :display: :TRagsearch[!] KIND REGEXP
" Scan the files registered in your tag files for REGEXP. Generate a 
" quickfix list. With [!], append to the given list. The quickfix list 
" can be viewed with commands like |:cw| or |:TRagcw|.
"
" The REGEXP has to match a single line. This uses |readfile()| and the 
" scans the lines. This is an alternative to |:vimgrep|.
" If you choose your identifiers wisely, this should guide you well 
" through your sources.
" See |trag#Grep()| for help on the arguments.
command! -nargs=1 -bang -bar TRagsearch call trag#Grep(<q-args>, empty("<bang>"))
command! -nargs=1 -bang -bar Tragsearch TRagsearch<bang> <args>


" :display: :TRaggrep REGEXP [GLOBPATTERN]
" A 99%-replacement for grep. The glob pattern is optional.
"
" Example: >
"   :TRaggrep foo *.vim
"   :TRaggrep bar
command! -nargs=+ -bang -bar -complete=file TRaggrep
            \ let g:trag_grepargs = ['.', <f-args>]
            \ | call trag#Grep(g:trag_grepargs[0] .' '. g:trag_grepargs[1], empty("<bang>"), g:trag_grepargs[2:-1])
            \ | unlet g:trag_grepargs
            \ | TRagcw
command! -nargs=+ -bang -bar -complete=file Traggrep TRaggrep<bang> <args>


" :display: :TRagsetfiles [FILELIST]
" The file list is set only once per buffer. If the list of the project 
" files has changed, you have to run this command on order to reset the 
" per-buffer list.
"
" If no filelist is given, collect the files in your tags files.
"
" Examples: >
"   :TRagsetfiles
"   :TRagsetfiles split(glob('foo*.txt'), '\n')
command! -nargs=? -bar -complete=file TRagsetfiles call trag#SetFiles(<args>)

" :display: :TRagaddfiles FILELIST
" Add more files to the project list.
command! -nargs=1 -bar -complete=file TRagaddfiles call trag#AddFiles(<args>)

" :display: :TRagclearfiles
" Remove any files from the project list.
command! TRagclearfiles call trag#ClearFiles()

" :display: :TRagGitFiles GIT_REPOS
command! -nargs=1 -bar -complete=dir TRagGitFiles call trag#SetGitFiles(<q-args>)


let &cpo = s:save_cpo
unlet s:save_cpo

