-- load standard vis module, providing parts of the Lua API
require('vis')

vis.events.win_open = function(win)
	vis.filetype_detect(win)
	vis:command('set theme subtle-256')
	vis:command('set tabwidth 2')
	vis:command('set expandtab yes')
	vis:command('set autoindent yes')
end
