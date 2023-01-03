local nnoremap = require("keymap").nnoremap
local vnoremap = require("keymap").vnoremap
local wk = require("which-key")

-- Quality of life
wk.register({
	name = "QoL",
	w = { "<cmd>w<cr>", "Save" },
	q = { "<cmd>q<cr>", "Quit" },
	x = { "<cmd>x<cr>", "Quit" },
	e = { "<cmd>Neotree toggle<cr>", "Explorer" },
}, { prefix = "<leader>" })

-- Navigating splits
nnoremap("<C-J>", "<C-W><C-J>")
nnoremap("<C-K>", "<C-W><C-K>")
nnoremap("<C-L>", "<C-W><C-L>")
nnoremap("<C-H>", "<C-W><C-H>")

-- Python Development
nnoremap("<leader>r", "<cmd>!python3 %<CR>")
nnoremap("<leader>d", "<cmd>bd!<CR>")

-- Rust Development
-- nnoremap("<leader>s", "<cmd>%! rustfmt<CR>")

-- Clear highlighting
nnoremap("<leader>,", "<cmd>noh<CR>")

-- System copy
vnoremap("<leader>c", '"+y<CR>')

-- Telescope
local telescope = require("telescope.builtin")
wk.register({
	f = {
		name = "Telescope",
		f = { telescope.find_files, "Find Files" },
		r = { telescope.oldfiles, "Recent Files" },
		g = { telescope.git_files, "Find in Git Project" },
		d = { telescope.live_grep, "Live Grep" },
		b = { telescope.buffers, "Buffers" },
		h = { telescope.help_tags, "Help Tags" },
	},
}, { prefix = "<leader>" })

-- Harpoon
wk.register({
	name = "Harpoon",
	a = { require("harpoon.mark").add_file, "Add File" },
	s = { require("harpoon.ui").toggle_quick_menu, "Toggle Quick Menu" },
	h = { require("harpoon.ui").nav_file(1), "Navigate to File 1" },
	j = { require("harpoon.ui").nav_file(2), "Navigate to File 2" },
	k = { require("harpoon.ui").nav_file(3), "Navigate to File 3" },
	l = { require("harpoon.ui").nav_file(4), "Navigate to File 4" },
}, { prefix = "<leader>" })

-- Terminal
-- nnoremap("<leader>t", "<cmd>ToggleTerm<CR>")
