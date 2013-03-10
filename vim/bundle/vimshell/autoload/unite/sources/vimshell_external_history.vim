"=============================================================================
" FILE: vimshell_external_history.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 27 Feb 2012.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

" Variables  "{{{
call unite#util#set_default('g:unite_source_vimshell_external_history_path',
      \ fnamemodify($SHELL, ':t') ==# 'zsh' ? expand('~/.zsh-history') :
      \ fnamemodify($SHELL, ':t') ==# 'bash' ? expand('~/.bash_history') :
      \ expand('~/.history')
      \)
"}}}

function! unite#sources#vimshell_external_history#define() "{{{
  return s:source
endfunction "}}}

let s:source = {
      \ 'name': 'vimshell/external_history',
      \ 'max_candidates' : 100,
      \ 'hooks' : {},
      \ 'action_table' : {},
      \ 'syntax' : 'uniteSource__VimshellExternalHistory',
      \ 'is_listed' : 0,
      \ 'filters' : ['matcher_default', 'sorter_nothing', 'converter_default'],
      \ }

function! s:source.hooks.on_init(args, context) "{{{
  let a:context.source__current_histories = filereadable(
        \ g:unite_source_vimshell_external_history_path) ?
        \ readfile(g:unite_source_vimshell_external_history_path) : []
  call map(a:context.source__current_histories,
        \ 'substitute(v:val,
        \"^\\%(\\d\\+/\\)\\+[:[:digit:]; ]\\+\\|^[:[:digit:]; ]\\+", "", "g")')
  let a:context.source__cur_keyword_pos = len(vimshell#get_prompt())
endfunction"}}}
function! s:source.hooks.on_syntax(args, context) "{{{
  syntax match uniteSource__VimshellHistorySpaces />-*\ze\s*$/
        \ containedin=uniteSource__VimshellHistory
  highlight default link uniteSource__VimshellHistorySpaces Comment
endfunction"}}}
function! s:source.hooks.on_post_filter(args, context) "{{{
  let cnt = 0

  for candidate in a:context.candidates
    let candidate.abbr =
          \ substitute(candidate.word, '\s\+$', '>-', '')
    let candidate.kind = 'vimshell/history'
    let candidate.action__complete_word = candidate.word
    let candidate.action__complete_pos =
          \ a:context.source__cur_keyword_pos
    let candidate.action__source_history_number = cnt
    let candidate.action__current_histories =
          \ a:context.source__current_histories
    let candidate.action__is_external = 1

    let cnt += 1
  endfor
endfunction"}}}

function! s:source.gather_candidates(args, context) "{{{
  return map(copy(a:context.source__current_histories),
        \ '{ "word" : v:val }')
endfunction "}}}

" vim: foldmethod=marker
