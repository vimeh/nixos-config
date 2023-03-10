local wk = require("which-key")

-- Quality of life
vim.keymap.set('i', 'jj', [[<esc>]])
wk.register({
  name = "QoL",
  w = { "<cmd>w<cr>", "Save" },
  q = { "<cmd>q<cr>", "Quit" },
  -- x = { "<cmd>x<cr>", "Quit" },
  e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
  gg = { "<cmd>LazyGit<cr>", "LazyGit" },
  t = { "<cmd>ToggleTerm direction=vertical<cr>", "VTerminal" },
  T = { "<cmd>ToggleTerm direction=horizontal<cr>", "HTerminal" },
  y = { '"+y', "SystemCopy", mode = "v" },
  p = { '"+p', "SystemPaste" },
  n = { "<cmd>enew<cr>", "New editor" },
}, { prefix = "<leader>" })

-- Clear highlighting
vim.keymap.set("n", "<leader>,", "<cmd>noh<CR>")


wk.register({
  vv = { "<cmd>vsplit<cr>", "VSplit" },
})
-- Windows
local splits = require('smart-splits')
-- moving between splits
-- TODO: loop over modes
vim.keymap.set('n', '<C-h>', splits.move_cursor_left)
vim.keymap.set('n', '<C-j>', splits.move_cursor_down)
vim.keymap.set('n', '<C-k>', splits.move_cursor_up)
vim.keymap.set('n', '<C-l>', splits.move_cursor_right)
vim.keymap.set('v', '<C-h>', splits.move_cursor_left)
vim.keymap.set('v', '<C-j>', splits.move_cursor_down)
vim.keymap.set('v', '<C-k>', splits.move_cursor_up)
vim.keymap.set('v', '<C-l>', splits.move_cursor_right)
vim.keymap.set('i', '<C-h>', splits.move_cursor_left)
vim.keymap.set('i', '<C-j>', splits.move_cursor_down)
vim.keymap.set('i', '<C-k>', splits.move_cursor_up)
vim.keymap.set('i', '<C-l>', splits.move_cursor_right)
-- and for terminal
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- resizing splits
-- TODO: add for other modes?
vim.keymap.set('n', '<C-S-r>', splits.start_resize_mode)
vim.keymap.set('n', '<C-S-h>', splits.resize_left)
vim.keymap.set('n', '<C-S-j>', splits.resize_down)
vim.keymap.set('n', '<C-S-k>', splits.resize_up)
vim.keymap.set('n', '<C-S-l>', splits.resize_right)

-- moving splits
require("winshift").setup()
vim.keymap.set('n', '<C-S-m>', [[<cmd>WinShift<cr>]])
-- Center buffer
wk.register({
  c = { "<cmd>ZenMode<cr>", "Zen Mode" },
}, { prefix = "<leader>" })

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


-- Indent/Unindent
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("n", "<Tab>", "v><C-\\><C-N>")
vim.keymap.set("v", "<S-Tab>", "<gv")
vim.keymap.set("n", "<S-Tab>", "v<<C-\\><C-N>")
vim.keymap.set("i", "<S-Tab>", "<C-\\><C-N>v<<C-\\><C-N>^i")

-- Trouble
wk.register({
  x = {
    name = "Trouble",
    x = { "<cmd>TroubleToggle<cr>", "Toggle" },
    w = { "cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
    d = { "cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
    q = { "cmd>TroubleToggle quickfix<cr>", "Quickfix" },
    l = { "cmd>TroubleToggle loclist<cr>", "Loclist" },
  },
}, { prefix = "<leader>" })


-- Persistence
wk.register({
  q = {
    name = "Persistence",
    s = { "<cmd>lua require('persistence').load()<cr>", "Restore for cwd" },
    l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  }
})
