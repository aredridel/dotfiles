" Vim syntax file
" Language: Test Anything Protocol
" Maintainer: Aria Stewart <aredridel@nbtsc.org>

syntax region line start=/^/ end=/$/ contains=@testResult,diagLine
syntax cluster testResult contains=okResult,notOkResult
syntax match okResult '^ok' nextgroup=testNumber skipwhite
syntax match notOkResult '^not ok' nextgroup=testNumber skipwhite
syntax match diagLine '^#.*$'
syntax match testNumber '\(\d+\)?'

highlight def link notOkResult Error
highlight def link okResult Constant
highlight def link diagLine Comment
highlight def link testNumber Number
