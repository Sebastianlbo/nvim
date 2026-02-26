local opt = vim.opt
local g = vim.g

local utils = require("utils")

g.mapleader = " "

mappings = require("core.mappings")
utils.load_mappings("general")

-------------------------------------- globals -----------------------------------------
g.transparency = false
-------------------------------------- plugins -----------------------------------------

local excluded = { codexnvim }
local plugins = utils.build_plugin_list(nil, { excluded = excluded })

require("lazy").setup(plugins, utils.lazy_nvim)
-------------------------------------- options ------------------------------------------
opt.laststatus = 3
opt.showmode = true

opt.cmdheight = 1 -- modern UI: command line only when needed
opt.pumheight = 8 -- keep completion menu short so docs have room
opt.scrolloff = 5 -- avoid sitting on the last line in the first place

opt.clipboard = "unnamedplus"
opt.cursorline = true

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.fillchars = {
	eob = " ",
	vert = "│",
	vertleft = "│",
	vertright = "│",
	verthoriz = "┼",
}

opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = true

-- Nvim intro
vim.opt.shortmess:append("sI")

-- Searching
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.swapfile = false

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

-- Always show absolute number on the current line, relative numbers elsewhere
opt.number = true
opt.relativenumber = true

-- disable some default providers
for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end

-------------------------------------- autocmds ------------------------------------------
local autocmd = vim.api.nvim_create_autocmd

-- dont list quickfix buffers
autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.opt_local.buflisted = false
	end,
})

-- which keys off in terminal buffer
autocmd("TermOpen", {
	callback = function(ev)
		vim.keymap.set("t", "<Space>", "<Space>", { buffer = ev.buf, nowait = true, silent = true })
	end,
})

-- :git -> :Git
vim.cmd([[
  cnoreabbrev <expr> git getcmdtype() == ':' && getcmdline() =~# '^\s*git\>' ? 'Git' : 'git'
]])

-- :telescope -> :Telescope
vim.cmd([[
  cnoreabbrev <expr> telescope getcmdtype() == ':' && getcmdline() =~# '^\s*telescope\>' ? 'Telescope' : 'telescope'
]])

-- :Q -> :q
vim.cmd([[
  cnoreabbrev <expr> Q getcmdtype() == ':' && getcmdline() =~# '^\s*Q\>' ? 'q' : 'Q'
]])

-- :W -> :w
vim.cmd([[
  cnoreabbrev <expr> W getcmdtype() == ':' && getcmdline() =~# '^\s*W\>' ? 'w' : 'W'
]])
