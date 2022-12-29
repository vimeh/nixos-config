-- Enable alignment
--let g:neoformat_basic_format_align = 1

-- Enable tab to space conversion
--let g:neoformat_basic_format_retab = 1

-- Enable trimmming of trailing whitespace
--let g:neoformat_basic_format_trim = 1


vim.api.nvim_create_autocmd("BufWritePre" , {
    pattern = {"*.py"},
    callback = function()
        vim.cmd("Neoformat")
    end,
})
