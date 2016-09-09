-- Copyright 2006-2016 Mitchell mitchell.att.foicica.com. See LICENSE.
-- JavaScript LPeg lexer.

local l = require('lexer')
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'javascript'}

-- Whitespace.
local ws = token(l.WHITESPACE, l.space^1)

-- Comments.
local line_comment = '//' * l.nonnewline_esc^0
local block_comment = '/*' * (l.any - '*/')^0 * P('*/')^-1
local comment = token(l.COMMENT, line_comment + block_comment)

-- Strings.
local sq_str = l.delimited_range("'")
local dq_str = l.delimited_range('"')
local template_str = l.delimited_range('`')
local regex_str = #P('/') * l.last_char_includes('+-*%^!=&|?:;,([{<>') *
                  l.delimited_range('/', true) * S('igm')^0
local string = token(l.STRING, sq_str + dq_str + template_str) +
               token(l.REGEX, regex_str)

-- Numbers.
local number = token(l.NUMBER, l.float + l.integer)

-- Keywords.
local keyword = token(l.KEYWORD, word_match{
  'abstract', 'boolean', 'break', 'byte', 'case', 'catch', 'char', 'class',
  'const', 'continue', 'debugger', 'default', 'delete', 'do', 'double', 'else',
  'enum', 'export', 'extends', 'false', 'final', 'finally', 'float', 'for',
  'function', 'goto', 'if', 'implements', 'import', 'in', 'instanceof', 'int',
  'interface', 'let', 'long', 'native', 'new', 'null', 'of', 'package',
  'private', 'protected', 'public', 'return', 'short', 'static', 'super',
  'switch', 'synchronized', 'this', 'throw', 'throws', 'transient', 'true',
  'try', 'typeof', 'var', 'void', 'volatile', 'while', 'with', 'yield'
})

-- Identifiers.
local identifier = token(l.IDENTIFIER, l.word)

local ass = P(1) * P('=')
local assignment = token('assignment', P('*=') + P('+=') + P('-=') + P( '/=') + P('|=') + P('&=') + P('^=') + P('%=') + P('='))

-- Operators.
local operator = token(l.OPERATOR, (S('+-/*%^&|') - ass + P('=>') + P('===') + P('==') + S('!&|?:;,.()[]{}<>')))

M._rules = {
  {'whitespace', ws},
  {'keyword', keyword},
  {'identifier', identifier},
  {'comment', comment},
  {'number', number},
  {'string', string},
  {'operator', operator },
  {'assignment', assignment },
}


M._tokenstyles = {
  assignment = l.STYLE_ASSIGNMENT
}

M._foldsymbols = {
  _patterns = {'[{}]', '/%*', '%*/', '//'},
  [l.OPERATOR] = {['{'] = 1, ['}'] = -1},
  [l.COMMENT] = {['/*'] = 1, ['*/'] = -1, ['//'] = l.fold_line_comments('//')}
}

return M
