local nnoremap = require("keymap").nnoremap
local vnoremap = require("keymap").vnoremap

-- Quality of life
nnoremap("<leader>w", "<cmd>w<CR>")
nnoremap("<leader>x", "<cmd>x<CR>")
nnoremap("<leader>q", "<cmd>q<CR>")

-- Navigating splits
nnoremap("<C-J>", "<C-W><C-J>")
nnoremap("<C-K>", "<C-W><C-K>")
nnoremap("<C-L>", "<C-W><C-L>")
nnoremap("<C-H>", "<C-W><C-H>")

-- Python Development
nnoremap("<leader>r", "<cmd>!python3 %<CR>")
nnoremap("<leader>d", "<cmd>bd!<CR>")

-- Neotree
nnoremap("<leader>e", "<cmd>Neotree toggle<CR>")
nnoremap("<leader>o", "<cmd>Neotree focus<CR>")

-- Rust Development
-- nnoremap("<leader>s", "<cmd>%! rustfmt<CR>")

-- Clear highlighting
nnoremap("<leader>,", "<cmd>noh<CR>")

-- System copy
vnoremap("<leader>c", '"+y<CR>')

-- Telescope
nnoremap("<leader>f", "<cmd>Telescope<CR>")

-- Harpoon
nnoremap("<leader>a", function()
	require("harpoon.mark").add_file()
end, silent)
nnoremap("<leader>s", function()
	require("harpoon.ui").toggle_quick_menu()
end, silent)
nnoremap("<leader>h", function()
	require("harpoon.ui").nav_file(1)
end, silent)
nnoremap("<leader>j", function()
	require("harpoon.ui").nav_file(2)
end, silent)
nnoremap("<leader>k", function()
	require("harpoon.ui").nav_file(3)
end, silent)
nnoremap("<leader>l", function()
	require("harpoon.ui").nav_file(4)
end, silent)

-- Terminal
-- nnoremap("<leader>t", "<cmd>ToggleTerm<CR>")
