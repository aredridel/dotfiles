-- load standard vis module, providing parts of the Lua API
require('vis')

vis.events.win_open = function(win)
	vis.filetype_detect(win)
	vis:command('set theme dark-16')
end
