"=============================================================================
" FILE: util.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 20 Jan 2013.
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

let s:V = vital#of('vimshell')
let s:List = vital#of('vimshell').import('Data.List')

function! vimshell#util#truncate_smart(...) "{{{
  return call(s:V.truncate_smart, a:000)
endfunction"}}}

function! vimshell#util#truncate(...) "{{{
  return call(s:V.truncate, a:000)
endfunction"}}}

function! vimshell#util#strchars(...) "{{{
  return call(s:V.strchars, a:000)
endfunction"}}}

function! vimshell#util#wcswidth(...) "{{{
  return call(s:V.wcswidth, a:000)
endfunction"}}}
function! vimshell#util#strwidthpart(...) "{{{
  return call(s:V.strwidthpart, a:000)
endfunction"}}}
function! vimshell#util#strwidthpart_reverse(...) "{{{
  return call(s:V.strwidthpart_reverse, a:000)
endfunction"}}}
if v:version >= 703
  " Use builtin function.
  function! vimshell#util#strwidthpart_len(str, width) "{{{
    let ret = a:str
    let width = strwidth(a:str)
    while width > a:width
      let char = matchstr(ret, '.$')
      let ret = ret[: -1 - len(char)]
      let width -= strwidth(char)
    endwhile

    return width
  endfunction"}}}
  function! vimshell#util#strwidthpart_len_reverse(str, width) "{{{
    let ret = a:str
    let width = strwidth(a:str)
    while width > a:width
      let char = matchstr(ret, '^.')
      let ret = ret[len(char) :]
      let width -= strwidth(char)
    endwhile

    return width
  endfunction"}}}
else
  function! vimshell#util#strwidthpart_len(str, width) "{{{
    let ret = a:str
    let width = vimshell#util#wcswidth(a:str)
    while width > a:width
      let char = matchstr(ret, '.$')
      let ret = ret[: -1 - len(char)]
      let width -= s:wcwidth(char)
    endwhile

    return width
  endfunction"}}}
  function! vimshell#util#strwidthpart_len_reverse(str, width) "{{{
    let ret = a:str
    let width = vimshell#util#wcswidth(a:str)
    while width > a:width
      let char = matchstr(ret, '^.')
      let ret = ret[len(char) :]
      let width -= s:wcwidth(char)
    endwhile

    return width
  endfunction"}}}
endif

function! s:buflisted(bufnr) "{{{
  return exists('t:unite_buffer_dictionary') ?
        \ has_key(t:unite_buffer_dictionary, a:bufnr) && buflisted(a:bufnr) :
        \ buflisted(a:bufnr)
endfunction"}}}

function! vimshell#util#expand(path) "{{{
  return s:V.substitute_path_separator(
        \ (a:path =~ '^\~') ? substitute(a:path, '^\~', expand('~'), '') :
        \ (a:path =~ '^\$\h\w*') ? substitute(a:path,
        \               '^\$\h\w*', '\=eval(submatch(0))', '') :
        \ a:path)
endfunction"}}}
function! vimshell#util#set_default_dictionary_helper(variable, keys, value) "{{{
  for key in split(a:keys, '\s*,\s*')
    if !has_key(a:variable, key)
      let a:variable[key] = a:value
    endif
  endfor
endfunction"}}}
function! vimshell#util#set_dictionary_helper(variable, keys, value) "{{{
  for key in split(a:keys, '\s*,\s*')
    let a:variable[key] = a:value
  endfor
endfunction"}}}

function! vimshell#util#substitute_path_separator(...) "{{{
  return call(s:V.substitute_path_separator, a:000)
endfunction"}}}
function! vimshell#util#is_windows(...) "{{{
  return call(s:V.is_windows, a:000)
endfunction"}}}
function! vimshell#util#escape_file_searching(...) "{{{
  return call(s:V.escape_file_searching, a:000)
endfunction"}}}
function! vimshell#util#sort_by(...) "{{{
  return call(s:List.sort_by, a:000)
endfunction"}}}
function! vimshell#util#uniq(...) "{{{
  return call(s:List.uniq, a:000)
endfunction"}}}

function! vimshell#util#has_vimproc(...) "{{{
  return call(s:V.has_vimproc, a:000)
endfunction"}}}

function! vimshell#util#input_yesno(message) "{{{
  let yesno = input(a:message . ' [yes/no]: ')
  while yesno !~? '^\%(y\%[es]\|n\%[o]\)$'
    redraw
    if yesno == ''
      echo 'Canceled.'
      break
    endif

    " Retry.
    call unite#print_error('Invalid input.')
    let yesno = input(a:message . ' [yes/no]: ')
  endwhile

  return yesno =~? 'y\%[es]'
endfunction"}}}

function! vimshell#util#is_cmdwin() "{{{
  return bufname('%') ==# '[Command Line]'
endfunction"}}}

function! vimshell#util#path2project_directory(...)
  return call(s:V.path2project_directory, a:000)
endfunction

function! vimshell#util#alternate_buffer() "{{{
  if bufnr('%') != bufnr('#') && s:buflisted(bufnr('#'))
    buffer #
    return
  endif

  let listed_buffer = filter(range(1, bufnr('$')),
        \ "s:buflisted(v:val) || v:val == bufnr('%')")
  let current = index(listed_buffer, bufnr('%'))
  if current < 0 || len(listed_buffer) < 3
    enew
    return
  endif

  execute 'buffer' ((current < len(listed_buffer) / 2) ?
        \ listed_buffer[current+1] : listed_buffer[current-1])
endfunction"}}}
function! vimshell#util#delete_buffer(...) "{{{
  let bufnr = get(a:000, 0, bufnr('%'))
  call vimshell#util#alternate_buffer()
  execute 'silent bdelete!' bufnr
endfunction"}}}
function! s:buflisted(bufnr) "{{{
  return exists('t:unite_buffer_dictionary') ?
        \ has_key(t:unite_buffer_dictionary, a:bufnr) && buflisted(a:bufnr) :
        \ buflisted(a:bufnr)
endfunction"}}}

" vim: foldmethod=marker
