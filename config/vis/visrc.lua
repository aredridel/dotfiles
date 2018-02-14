-- load standard vis module, providing parts of the Lua API
require('vis')
require('plugins/filetype')
require('plugins/textobject-lexer')

vis.events.subscribe(vis.events.INIT, function()
--	vis:command('set theme subtle-256')
--	vis:command('set theme light-16')
	vis:command('set theme base16-spacemacs')
end)


vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command('set tabwidth 2')
	vis:command('set expandtab yes')
	vis:command('set autoindent yes')
end)
