return {
	{ 'elixir-editors/vim-elixir' },
	{ 'haya14busa/vim-edgemotion' },
	{ 'stevearc/oil.nvim' },
	{ 'tpope/vim-markdown' },
	{ 'jceb/vim-orgmode' },
	{ 'kylechui/nvim-surround' },
	{ 'preservim/vim-pencil' },
	{ 'dbmrq/vim-ditto' },
	{ 'kana/vim-textobj-user' },
	{ 'preservim/vim-textobj-quote' },
	{ 'preservim/vim-textobj-sentence' },
	{ 'tommcdo/vim-exchange' },
	{ 'pangloss/vim-javascript' },
	{ 'tpope/vim-commentary' },
	{ 'mattn/emmet-vim' },
	{ 'challenger-deep-theme/vim',     lazy = false },
	{ 'evanleck/vim-svelte' },
	{ 'ciaranm/detectindent',          lazy = false },
	{ 'leafgarland/typescript-vim' },
	{ 'udalov/kotlin-vim' },
	{ 'jwalton512/vim-blade' },
	{ 'vim-crystal/vim-crystal' },
	{
		'nvim-treesitter/nvim-treesitter',
		config = function()
			vim.cmd([[TSUpdate]])
		end
	},
	{ 'nvim-telescope/telescope.nvim' },
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
		},
		config = function()
			-- Set up nvim-cmp.
			local cmp = require 'cmp'

			cmp.setup({
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
				}, {
					{ name = 'buffer' },
				})
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' }
				}
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path' }
				}, {
					{ name = 'cmdline' }
				}),
				matching = { disallow_symbol_nonprefix_matching = false }
			})
		end
	}
}
