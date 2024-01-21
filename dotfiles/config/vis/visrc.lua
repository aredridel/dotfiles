-- load standard vis module, providing parts of the Lua API
require('vis')
-- require('plugins/filetype')
-- require('plugins/textobject-lexer')
require('plugins/surround')
lspc = require('plugins/vis-lspc')
lspc.ls_map.javascript.cmd = 'typescript-language-server --stdio --tsserver-path=/opt/homebrew/bin/tsserver'

--vis.events.subscribe(vis.events.INIT, function()
--	vis:command('set theme subtle-256')
--	vis:command('set theme light-16')
--	vis:command('set theme importance')
-- end)


-- vis.events.subscribe(vis.events.WIN_OPEN, function(win)
--	vis:command('set tabwidth 2')
--	vis:command('set expandtab yes')
--	vis:command('set autoindent yes')
--end)
