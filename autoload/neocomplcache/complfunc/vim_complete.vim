"=============================================================================
" FILE: vim_complete.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 29 May 2010
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

function! neocomplcache#complfunc#vim_complete#initialize()"{{{
  " Initialize.
  let s:completion_length = has_key(g:NeoComplCache_PluginCompletionLength, 'vim_complete') ? 
        \ g:NeoComplCache_PluginCompletionLength['vim_complete'] : g:NeoComplCache_KeywordCompletionStartLength

  " Set caching event.
  autocmd neocomplcache FileType vim call neocomplcache#complfunc#vim_complete#helper#on_filetype()

  " Add command.
  command! -nargs=? -complete=buffer NeoComplCacheCachingVim call neocomplcache#complfunc#vim_complete#helper#recaching(<q-args>)
endfunction"}}}

function! neocomplcache#complfunc#vim_complete#finalize()"{{{
  delcommand NeoComplCacheCachingVim
endfunction"}}}

function! neocomplcache#complfunc#vim_complete#get_keyword_pos(cur_text)"{{{
  if &filetype != 'vim'
    return -1
  endif

  let l:cur_text = neocomplcache#complfunc#vim_complete#get_cur_text()

  if l:cur_text =~ '^\s*"'
    " Comment.
    return -1
  endif

  let l:pattern = '\.$\|' . neocomplcache#get_keyword_pattern_end('vim')
  if l:cur_text !~ '^[[:digit:],[:space:]$''<>]*\h\w*$'
    let l:command_completion = neocomplcache#complfunc#vim_complete#helper#get_completion_name(
          \neocomplcache#complfunc#vim_complete#get_command(l:cur_text))
    if l:command_completion =~ '\%(dir\|file\|shellcmd\)'
      let l:pattern = neocomplcache#get_keyword_pattern_end('filename')
    endif
  endif
  
  let l:cur_keyword_pos = match(a:cur_text, l:pattern)

  if g:NeoComplCache_EnableWildCard
    " Check wildcard.
    let l:cur_keyword_pos = neocomplcache#match_wildcard(a:cur_text, l:pattern, l:cur_keyword_pos)
  endif

  return l:cur_keyword_pos
endfunction"}}}

function! neocomplcache#complfunc#vim_complete#get_complete_words(cur_keyword_pos, cur_keyword_str)"{{{
  let l:cur_text = neocomplcache#complfunc#vim_complete#get_cur_text()
  if (neocomplcache#is_auto_complete() && l:cur_text !~ '\h\w*\.\%(\h\w*\%(()\?\)\?\)\?$'
        \&& len(a:cur_keyword_str) < s:completion_length)
    return []
  endif
  
  if l:cur_text =~ '\h\w*\.\%(\h\w*\%(()\?\)\?\)\?$' && a:cur_keyword_str=~ '^\.'
    " Dictionary.
    let l:list = neocomplcache#complfunc#vim_complete#helper#var_dictionary(l:cur_text, a:cur_keyword_str)
  elseif a:cur_keyword_str =~# '^&\%([gl]:\)\?'
    " Options.
    let l:prefix = matchstr(a:cur_keyword_str, '&\%([gl]:\)\?')
    let l:options = deepcopy(neocomplcache#complfunc#vim_complete#helper#option(l:cur_text, a:cur_keyword_str))
    for l:keyword in l:options
      let l:keyword.word = l:prefix . l:keyword.word
      let l:keyword.abbr = l:prefix . l:keyword.abbr
    endfor
    let l:list = l:options
  elseif l:cur_text =~# '\<has(''\h\w*$'
    " Features.
    let l:list = neocomplcache#complfunc#vim_complete#helper#feature(l:cur_text, a:cur_keyword_str)
  elseif l:cur_text =~ '^\$'
    " Environment.
    let l:list = neocomplcache#complfunc#vim_complete#helper#environment(l:cur_text, a:cur_keyword_str)
  elseif l:cur_text =~ '`=[^`]*$'
    " Expression.
    let l:list = neocomplcache#complfunc#vim_complete#helper#expression(l:cur_text, a:cur_keyword_str)
  else
    if l:cur_text =~ '^[[:digit:],[:space:]$''<>]*!\s*\f\+$'
      " Shell commands.
      let l:list = neocomplcache#complfunc#vim_complete#helper#shellcmd(l:cur_text, a:cur_keyword_str)
    elseif l:cur_text =~ '^[[:digit:],[:space:]$''<>]*\h\w*$'
      " Commands.
      let l:list = neocomplcache#complfunc#vim_complete#helper#command(l:cur_text, a:cur_keyword_str)
    else
      " Commands args.
      
      let l:command = neocomplcache#complfunc#vim_complete#get_command(l:cur_text)
      let l:list = neocomplcache#complfunc#vim_complete#helper#get_command_completion(l:command, l:cur_text, a:cur_keyword_str)
      
      if l:cur_text =~ '[[(,{]'
        " Expression.
        let l:list += neocomplcache#complfunc#vim_complete#helper#expression(l:cur_text, a:cur_keyword_str)
      endif
    endif
  endif

  return neocomplcache#keyword_filter(l:list, substitute(a:cur_keyword_str, '#', '*#', 'g'))
endfunction"}}}

function! neocomplcache#complfunc#vim_complete#get_rank()"{{{
  return 100
endfunction"}}}

function! neocomplcache#complfunc#vim_complete#get_cur_text()"{{{
  let l:cur_text = neocomplcache#get_cur_text()
  let l:line = line('.')
  while l:cur_text =~ '^\s*\\' && l:line > 1
    let l:cur_text = getline(l:line - 1) . substitute(l:cur_text, '^\s*\\', '', '')
    let l:line -= 1
  endwhile

  return split(l:cur_text, '\s\+|\s\+\|<bar>', 1)[-1]
endfunction"}}}
function! neocomplcache#complfunc#vim_complete#get_command(cur_text)"{{{
  return matchstr(a:cur_text, '\<\%(\d\+\)\?\zs\h\w*\ze!\?\|\<\%([[:digit:],[:space:]$''<>]\+\)\?\zs\h\w*\ze/.*')
endfunction"}}}

" vim: foldmethod=marker
