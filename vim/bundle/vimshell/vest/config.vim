" Tests for vimshell.

scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

Context Vesting.run()
  It tests prompt.
    let g:vimshell_prompt = "'% ' "
    let g:vimshell_secondary_prompt = 'aaa '
    VimShellCreate -toggle
    Should vimshell#get_prompt() ==# "'% ' "
    Should vimshell#get_secondary_prompt() ==# 'aaa '
    VimShellCreate -toggle

    let g:vimshell_user_prompt = "3\ngetcwd()"
    VimShellCreate -toggle
    Should vimshell#get_user_prompt() ==# "3\ngetcwd()"
    VimShellCreate -toggle

    let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
    VimShellCreate -toggle
    Should vimshell#get_user_prompt() ==#
          \ 'fnamemodify(getcwd(), ":~")'
    VimShellCreate -toggle
  End

  It tests options.
    VimShellCreate -toggle -prompt=foo\ bar
    Should vimshell#get_prompt() ==# 'foo bar'
    VimShellCreate -toggle
  End
End

Fin

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}

" vim:foldmethod=marker:fen:
