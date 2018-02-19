-- base16-vis (https://github.com/pshevtsov/base16-vis)
-- by Petr Shevtsov
-- Spacemacs scheme by Nasser Alshammari (https://github.com/nashamri/spacemacs-theme)

local lexers = vis.lexers

local colors = {
	['black'] = '#000000',
	['gray00'] = '#1f2022',
	['gray01'] = '#282828',
	['gray02'] = '#444155',
	['gray03'] = '#585858',
	['gray04'] = '#b8b8b8',
	['gray05'] = '#a3a3a3',
	['gray06'] = '#e8e8e8',
	['gray07'] = '#f8f8f8',
	['red'] = '#f2241f',
	['tangerine'] = '#ffa500',
	['mustard'] = '#b1951d',
	['green'] = '#67b11d',
	['kelley'] = '#2d9574',
	['skyblue'] = '#4f97d7',
	['magenta'] = '#a31db1',
	['purple'] = '#9341f2',
}

lexers.colors = colors

local fg = ',fore:'..colors.gray07..','
local bg = ',back:'..colors.black..','

local norm = ',fore:'..colors.gray05..','

lexers.STYLE_DEFAULT = bg..fg
lexers.STYLE_NOTHING = bg
lexers.STYLE_CLASS = 'fore:'..colors.mustard
lexers.STYLE_COMMENT = lexers.STYLE_DEFAULT
lexers.STYLE_CONSTANT = lexers.STYLE_DEFAULT
lexers.STYLE_DEFINITION = 'fore:'..colors.magenta
lexers.STYLE_ERROR = 'fore:'..colors.red..',italics'
lexers.STYLE_FUNCTION = 'fore:'..colors.green
lexers.STYLE_KEYWORD = 'fore:'..colors.magenta
lexers.STYLE_LABEL = 'fore:'..colors.mustard
lexers.STYLE_NUMBER = 'fore:'..colors.skyblue
lexers.STYLE_BRACKETS = 'fore:'..colors.gray05
lexers.STYLE_UNIMPORTANT = 'fore:'..colors.gray05
lexers.STYLE_OPERATORS = ',fore:'..colors.skyblue
lexers.STYLE_ASSIGNMENT = ',fore:'..colors.tangerine
lexers.STYLE_REGEX = 'fore:'..colors.skyblue
lexers.STYLE_STRING = 'fore:'..colors.skyblue
lexers.STYLE_PREPROCESSOR = 'fore:'..colors.mustard
lexers.STYLE_TAG = 'fore:'..colors.mustard
lexers.STYLE_TYPE = 'fore:'..colors.mustard
lexers.STYLE_VARIABLE = 'fore:'..colors.skyblue
lexers.STYLE_WHITESPACE = 'fore:'..colors.gray02
lexers.STYLE_EMBEDDED = 'fore:'..colors.purple
lexers.STYLE_IDENTIFIER = lexers.STYLE_DEFAULT

lexers.STYLE_LINENUMBER = 'fore:'..colors.gray02..',back:'..colors.gray00
lexers.STYLE_CURSOR = 'fore:'..colors.gray00..',back:'..colors.gray05
lexers.STYLE_CURSOR_PRIMARY = 'fore:'..colors.gray00..',back:'..colors.gray05
lexers.STYLE_CURSOR_LINE = 'back:'..colors.gray01
lexers.STYLE_COLOR_COLUMN = 'back:'..colors.gray01
lexers.STYLE_SELECTION = 'back:'..colors.gray01
lexers.STYLE_STATUS = 'fore:'..colors.mustard..',back:'..colors.gray02
lexers.STYLE_STATUS_FOCUSED = 'fore:'..colors.tangerine..',back:'..colors.gray02
lexers.STYLE_SEPARATOR = lexers.STYLE_DEFAULT
lexers.STYLE_INFO = 'fore:default,back:default,bold'
lexers.STYLE_EOF = ''
