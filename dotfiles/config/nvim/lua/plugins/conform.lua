return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      vue = { 'prettierd', 'prettier', stop_after_first = true },
    },
  },
}
