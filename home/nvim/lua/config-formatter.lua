-- Enable alignment
vim.g.neoformat_basic_format_align = 1

-- Enable tab to space conversion
vim.g.neoformat_basic_format_retab = 1

-- Enable trimmming of trailing whitespace
vim.g.neoformat_basic_format_trim = 1

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.py" },
  callback = function() vim.cmd("Neoformat") end
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.nix" },
  callback = function() vim.cmd("Neoformat") end
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.rs" },
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 200 })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua" },
  callback = function() vim.lsp.buf.format { async = true } end
})
