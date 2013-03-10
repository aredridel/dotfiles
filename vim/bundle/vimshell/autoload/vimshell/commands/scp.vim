"=============================================================================
" FILE: scp.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 22 Jun 2012.
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

let s:command = {
      \ 'name' : 'scp',
      \ 'kind' : 'external',
      \ 'description' : 'ssh {src} {dest}',
      \}
function! s:command.complete(args) "{{{
  if !exists('*unite#get_all_sources')
        \ || empty(unite#get_all_sources('ssh'))
    return []
  endif

  " Use unite-ssh function.
  let arglead = get(a:args, -1, '')
  let cmdline = join(a:args)
  let cursorpos = len(cmdline)
  let _ =  unite#sources#ssh#command_complete_host(
        \ arglead, cmdline, len(cmdline)) +
        \ vimshell#complete#helper#files(arglead)

  if !neocomplcache#is_auto_complete()
    " Manual complete only.
    let ssh_files = map(unite#sources#ssh#complete_file(
        \ split('//' . substitute(arglead,
        \     ':', '/', ''), ':'), unite#get_context(),
        \ arglead, cmdline, cursorpos),
        \ "substitute(v:val, ':\\d\\+/', ':', '')")
    let _ += ssh_files
  endif

  return _
endfunction"}}}

function! vimshell#commands#scp#define()
  return s:command
endfunction
