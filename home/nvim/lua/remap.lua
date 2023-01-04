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
  gg = { "<cmd>LazyGit<cr>", "LazyGit" }
}, { prefix = "<leader>" })

-- Navigating splits
nnoremap("<C-J>", "<C-W><C-J>")
nnoremap("<C-K>", "<C-W><C-K>")
nnoremap("<C-L>", "<C-W><C-L>")
nnoremap("<C-H>", "<C-W><C-H>")
-- todo
-- ctrl+shift to resize splits. bettersplit plugin?

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
  h = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "Nav to File 1" },
  j = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "Nav to File 2" },
  k = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "Nav to File 3" },
  l = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "Nav to File 4" },
}, { prefix = "<leader>" })
