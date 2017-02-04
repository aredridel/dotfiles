-- Copyright 2006-2015 Mitchell mitchell.att.foicica.com. See LICENSE.
-- JavaScript LPeg lexer.
-- [dr] added jsx and es6 support

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
local regex_str = #P('/') * l.last_char_includes('+-*%^!=&|?:;,([{<>') *
                  l.delimited_range('/', true) * S('igm')^0
local string = token(l.STRING, sq_str + dq_str) + token(l.REGEX, regex_str)

-- Numbers.
local number = token(l.NUMBER, l.float + l.integer)

-- Keywords.
local keyword = token(l.KEYWORD, word_match{
  'abstract', 'boolean', 'break', 'byte', 'case', 'catch', 'char', 'class',
  'const', 'continue', 'debugger', 'default', 'delete', 'do', 'double', 'else',
  'enum', 'export', 'extends', 'false', 'final', 'finally', 'float', 'for',
  'goto', 'if', 'implements', 'import', 'in', 'instanceof', 'int',
  'interface', 'let', 'long', 'native', 'new', 'null', 'package', 'private',
  'protected', 'public', 'return', 'short', 'static', 'super', 'switch',
  'synchronized', 'this', 'throw', 'throws', 'transient', 'true', 'try',
  'typeof', 'var', 'void', 'volatile', 'while', 'with', 'yield', 'function',
  'from',
})

-- Identifiers.
local identifier = token(l.IDENTIFIER, l.word)
local variable = token(l.VARIABLE, l.word)
local funcname = token(l.FUNCTION, l.word) - keyword

-- Operators.
local operator = token(l.OPERATOR, S('+-/*%^!=&|?:;,.()[]{}<>'))


local sig_default_param = token(l.OPERATOR, S('=')) * (identifier + string + number)
local splat = token(l.OPERATOR, P('...'))

local func_sig = ws^0 * splat^-1 * variable * ws^0 * sig_default_param^0 * token(l.OPERATOR, S(','))^0
local func_sig_parenthesis = token(l.OPERATOR, S('(')) * func_sig^0 * ws^0 * token(l.OPERATOR, S(')'))

-- es6 classes form: "XXX() {}"
local func3 = funcname * ws^0 * func_sig_parenthesis * ws^0 * token(l.OPERATOR, S('{'))
local get_set = token(l.KEYWORD, P('get') + P('set'))
local func3_get_set = get_set * ws^1 * func3

-- form: "function XXX()"
local func1 = token(l.KEYWORD, P('function')) * ws^1 * funcname * ws^0 * func_sig_parenthesis
-- form: "XXX = function()"
local func2 = funcname * ws^0 * token(l.OPERATOR, S('=:')) * ws^0 * token(l.KEYWORD, P('function')) * ws^0 * func_sig_parenthesis

-- colorize empty () as variable
local lambda = (token(l.VARIABLE, P('()')) + variable + func_sig_parenthesis) * ws^0 * token(l.OPERATOR, S('=')) * token(l.OPERATOR, S('>'))
-- form: XXX = () => asasd
local func4 = funcname * ws^0 * token(l.OPERATOR, S('=:')) * ws^0 * lambda

local in_jsx_attr = P(function(input, index)
  local _, idx_close, idx_open
  local idx = index
  local stack = 1
  while stack > 0 do
    _, idx_close = input:find('}', idx)
    _, idx_open = input:find('{', idx)

    if idx_close and (not idx_open or idx_close < idx_open) then
      stack = stack - 1
      idx = idx_close + 1
    elseif idx_open then
      stack = stack + 1
      idx = idx_open + 1
    end
    if not idx_close and not idx_open then
      idx = nil
      break
    end;
  end
  return idx - 1
end)

-- Dirk: not sure wheter this newline stuff is really needed
local newline = (P"\r\n" + P"\n\r" + S"\r\n")

local ws_nl = (ws^0 * comment * newline * ws^0) + ws^1
local jsx_tag = l.word * (P('.') * l.word)^0

local jsx_attr_js = token(l.OPERATOR, S('{')) * token('embedded', in_jsx_attr) * token(l.OPERATOR, S('}'))
local jsx_attribute = ws_nl * token(l.LABEL, l.word) * (ws^0 * P('=') * ws^0 * (string + jsx_attr_js))^0
local jsx_element = token(l.TYPE, P('<') * jsx_tag) * jsx_attribute^0 * ws_nl^0 * token(l.TYPE, P('/>') + P('>'))
local jsx_closing_element = token(l.TYPE, P('</') * jsx_tag * P('>'))

-- es6 classes
local classname = token(l.KEYWORD, P('class')) * ws^1 * token(l.CLASS, l.word)

M._rules = {
  {'whitespace', ws},
  {'func1', func1},
  {'func2', func2},
  {'func3', func3},
  {'func3_get_set', func3_get_set},

  {'func4', func4},
  {'lambda', lambda},
  {'class', classname},

  {'jsx_element', jsx_element},
  {'jsx_closing_element', jsx_closing_element},

  {'keyword', keyword},
  {'identifier', identifier},

  {'comment', comment},
  {'number', number},
  {'string', string},
  {'operator', operator},

}

M._foldsymbols = {
  _patterns = {'[{}]', '/%*', '%*/', '//'},
  [l.OPERATOR] = {['{'] = 1, ['}'] = -1},
  [l.COMMENT] = {['/*'] = 1, ['*/'] = -1, ['//'] = l.fold_line_comments('//')}
}

M._LEXBYLINE = false
return M