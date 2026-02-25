local M = {}

M.general = {
	i = {
		-- go to  beginning and end
		["<C-b>"] = { "<ESC>^i", "Beginning of line" },
		["<C-e>"] = { "<End>", "End of line" },

		-- navigate within insert mode
		["<C-h>"] = { "<Left>", "Move left" },
		["<C-l>"] = { "<Right>", "Move right" },
		["<C-j>"] = { "<Down>", "Move down" },
		["<C-k>"] = { "<Up>", "Move up" },

		-- macOS-default deletions
		["<A-BS>"] = { "<C-w>", "Delete previous word" }, -- Option + Backspace
	},

	n = {
		["<Space>"] = { "<Nop>", silent = true },
		["<BS>"] = { "<Nop>", silent = true },

		["<leader>a"] = {
			function()
				vim.cmd("wincmd t")
			end,
			"Focus First Split",
		},

		["<Esc>"] = { "<cmd> noh <CR>", "Clear highlights" },

		-- Moving through jumplist entries
		["<leader>j"] = { "<C-o>", "Jump back" },
		["<leader>k"] = { "<C-i>", "Jump forward" },

		-- switch between windows
		["<C-h>"] = { "<C-w>h", "Window left" },
		["<C-l>"] = { "<C-w>l", "Window right" },
		["<C-j>"] = { "<C-w>j", "Window down" },
		["<C-k>"] = { "<C-w>k", "Window up" },

		-- save
		["<C-s>"] = { "<cmd> w <CR>", "Save file" },

		-- line numbers
		["<leader>rn"] = { "<cmd> set rnu! <CR>", "Toggle relative number" },

		-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
		-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
		["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
		["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },

		["<leader>fm"] = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"LSP formatting",
		},
		["<leader>sv"] = { "<cmd>vs<CR>", "Split window vertically" },
		["<leader>sh"] = { "<cmd>sp<CR>", "Split window horizontally" },
	},

	t = {
		["<Esc>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },
		["<C-x>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },
	},

	v = {
		["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
		["<"] = { "<gv", "Indent line" },
		[">"] = { ">gv", "Indent line" },
		["<leader>rw"] = {
			"y:%s/<C-r>0//gc<Left><Left><Left>",
			"Substitute selection everywhere with confirm",
		},

		-- Move selected line / block of text in visual mode
		["J"] = { ":m '>+1<CR>gv=gv", "Move selection down", opts = { noremap = true } },
		["K"] = { ":m '<-2<CR>gv=gv", "Move selection up", opts = { noremap = true } },
	},

	x = {
		["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
		["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		-- Don't copy the replaced text after pasting in visual mode
		-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
		["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "Dont copy replaced text", opts = { silent = true } },
	},
}

-- Bufferline
M.tabufline = {
	plugin = true,

	n = {
		-- cycle through buffers
		["<tab>"] = { "<cmd>BufferLineCycleNext<CR>", "Goto next buffer" },

		["<S-tab>"] = { "<cmd>BufferLineCyclePrev<CR>", "Goto prev buffer" },

		-- close buffer + hide terminal buffer
		["<leader>x"] = { "<cmd>bp|bd #<CR>", "Close buffer" },
	},
}

-- Comment
M.comment = {
	plugin = true,

	-- toggle comment in both modes
	n = {
		["<leader>/"] = {
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			"Toggle comment",
		},
	},

	v = {
		["<leader>/"] = {
			"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
			"Toggle comment",
		},
	},
}

-- LSP
M.lspconfig = {
	plugin = true,

	n = {
		["<leader>gD"] = {
			function()
				vim.lsp.buf.declaration()
			end,
			"LSP declaration",
		},

		["<leader>gd"] = {
			function()
				vim.lsp.buf.definition()
			end,
			"LSP definition",
		},

		["<leader>gi"] = {
			function()
				vim.lsp.buf.implementation()
			end,
			"LSP implementation",
		},

		["<leader>lr"] = {
			function()
				vim.lsp.buf.rename()
			end,
			"LSP rename",
		},

		["<leader>gr"] = {
			function()
				vim.lsp.buf.references()
			end,
			"LSP references",
		},

		["<leader>lf"] = {
			function()
				vim.diagnostic.open_float()
			end,
			"Floating diagnostic",
		},

		["[d"] = {
			function()
				vim.diagnostic.goto_prev({ float = { border = "rounded" } })
			end,
			"Goto prev",
		},

		["]d"] = {
			function()
				vim.diagnostic.goto_next({ float = { border = "rounded" } })
			end,
			"Goto next",
		},

		["<leader>wa"] = {
			function()
				vim.lsp.buf.add_workspace_folder()
			end,
			"Add workspace folder",
		},

		["<leader>wr"] = {
			function()
				vim.lsp.buf.remove_workspace_folder()
			end,
			"Remove workspace folder",
		},

		["<leader>wl"] = {
			function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end,
			"List workspace folders",
		},
	},

	v = {
		["<leader>ca"] = {
			function()
				vim.lsp.buf.code_action()
			end,
			"LSP code action",
		},
	},
}

-- Nvim-tree
M.nvimtree = {
	plugin = true,

	n = {
		["<leader>a"] = {
			function()
				vim.cmd("wincmd t")
			end,
			"Focus First Split",
		},

		-- alias toggle
		["<leader>n"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },

		-- focus
		["<leader>e"] = {
			function()
				vim.cmd("NvimTreeFocus")
				vim.cmd("NvimTreeRefresh")
			end,
			"Focus & refresh nvimtree",
		},
	},
}

-- Lazygit
M.lazygit = {
	plugin = true,

	n = {
		["<leader>gs"] = {
			"<cmd>LazyGit<cr><cmd>hi LazyGitFloat guibg=NONE guifg=NONE<cr><cmd>setlocal winhl=NormalFloat:LazyGitFloat<cr>",
			"LazyGit",
		},
	},
}

-- Telescope
M.telescope = {
	plugin = true,

	n = {
		["<leader>tgc"] = { "<cmd>Telescope git_commits<CR>", "Telescope Git Commits" },
		["<leader>tgd"] = { "<cmd>Telescope git_status<CR>", "Telescope Git Diff" },
		["<leader>tm"] = { "<cmd>Telescope marks<CR>", "Telescope Marks" },
		["<BS><leader>"] = { "<cmd>Telescope buffers show_all_buffers=true<CR>", "Telescope Buffers (all)" },
		["<leader><BS>"] = { "<cmd>Telescope buffers show_all_buffers=true<CR>", "Telescope Buffers (all)" },
		["_"] = { "<cmd>Telescope buffers show_all_buffers=true<CR>", "Telescope Buffers (all)" },
		["<leader>th"] = { "<cmd>Telescope help_tags <CR>", "Help page" },
		["<leader>tj"] = { "<cmd>Telescope find_files<CR>", "Telescope Find Files" },
		["<leader>ta"] = { "<cmd>Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
		["<leader>to"] = { "<cmd>Telescope oldfiles<CR>", "Telescope Oldfiles" },
		["<leader>td"] = { "<cmd>Telescope diagnostics bufnr=0<CR>", "Telescope Diagnostics (current file)" },
		["<leader>tad"] = { "<cmd>Telescope diagnostics<CR>", "Telescope All Diagnostics" },
		["<leader>tw"] = { "<cmd>Telescope live_grep<CR>", "Telescope Grep Word" },
		["<leader>tx"] = {
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end,
			"Telescope grep open Word",
		},
		["<leader>t/"] = {
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(
					require("telescope.themes").get_dropdown({ previewer = false })
				)
			end,
			"Telescope Find",
		},
	},
}

-- Todo Comments
M.todo_comments = {
	plugin = true,

	n = {
		["<leader>st"] = { "<cmd>TodoTelescope<CR>", "Search todos" },
	},
}

-- Nvterm
M.nvterm = {
	plugin = true,

	n = {
		["<leader>v"] = {
			function()
				local ok, term = pcall(require, "nvterm.terminal")
				if ok and term and term.toggle then
					term.toggle("vertical")
				end
			end,
			"Toggle vertical term",
		},
		["<leader>i"] = {
			function()
				local ok, term = pcall(require, "nvterm.terminal")
				if ok and term and term.toggle then
					term.toggle("float")
				end
			end,
			"Toggle floating term",
		},
	},
}

-- Which-key
M.whichkey = {
	plugin = true,

	n = {
		["<leader>wK"] = {
			function()
				vim.cmd("WhichKey")
			end,
			"Which-key all keymaps",
		},
		["<leader>wk"] = {
			function()
				local input = vim.fn.input("WhichKey: ")
				vim.cmd("WhichKey " .. input)
			end,
			"Which-key query lookup",
		},
	},
}

M.blankline = {
	plugin = true,

	n = {},
}

-- Gitsigns
M.gitsigns = {
	plugin = true,

	n = {
		["]c"] = {
			function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					require("gitsigns").next_hunk()
				end)
				return "<Ignore>"
			end,
			"Jump to next hunk",
			opts = { expr = true },
		},

		["[c"] = {
			function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					require("gitsigns").prev_hunk()
				end)
				return "<Ignore>"
			end,
			"Jump to prev hunk",
			opts = { expr = true },
		},

		["<leader>hs"] = {
			function()
				require("gitsigns").stage_hunk()
			end,
			"Hunk Stage",
		},

		["<leader>hd"] = {
			function()
				require("gitsigns").preview_hunk()
			end,
			"Hunk Preview",
		},

		["<leader>hu"] = {
			function()
				require("gitsigns").stage_hunk()
			end,
			"Hunk Unstage",
		},

		["<leader>gb"] = {
			function()
				require("gitsigns").blame_line({ full = true })
			end,
			"Blame line",
		},

		["<leader>gtb"] = {
			function()
				require("gitsigns").toggle_current_line_blame()
			end,
			"Toggle blame",
		},

		["<leader>gdt"] = {
			function()
				require("gitsigns").diffthis()
			end,
			"Git Diff this file",
		},

		["<leader>gdm"] = {
			function()
				require("gitsigns").diffthis("origin/main")
			end,
			"Git Diff against origin/main",
		},

		["<leader>gfs"] = {
			function()
				require("gitsigns").stage_buffer()
			end,
			"Git File Stage",
		},

		["<leader>gfu"] = {
			function()
				require("gitsigns").reset_buffer_index()
			end,
			"Git File Unstage",
		},
	},
}

-- Diffview leader mappings
M.diffview = {
	plugin = true,

	n = {
		["<leader>gda"] = { "<cmd>DiffviewOpen <CR>", "Git Diff files All" },
		["<leader>gds"] = { "<cmd>DiffviewOpen --cached<CR>", "Git Diff Staged All" },
	},
}

-- Easy Align
M.easy_align = {
	plugin = true,

	n = {
		["ga"] = { "<Plug>(EasyAlign)", "EasyAlign", opts = { noremap = false } },
	},

	x = {
		["ga"] = { "<Plug>(EasyAlign)", "EasyAlign Visual Mode", opts = { noremap = false } },
	},
}

-- Vim-slime
M.vim_slime = {
	plugin = true,

	n = {
		["<leader>ss"] = { "V<Plug>SlimeRegionSend", "Slime send line", opts = { noremap = false, silent = true } },
	},

	v = {
		["<leader>ss"] = { "<Plug>SlimeRegionSend", "Slime send selection", opts = { noremap = false, silent = true } },
	},
}

-- Codex
M.codex = {
	plugin = true,

	n = {
		["<leader>cc"] = { "<cmd>CodexToggle<CR>", "Toggle Codex" },
	},

	v = {
		["<leader>cc"] = {
			function()
				local ok_lazy, lazy = pcall(require, "lazy")
				if ok_lazy then
					lazy.load({ plugins = { "codex.nvim" } })
				end
				local codex = require("codex")
				if type(codex.send_visual_selection) == "function" then
					codex.send_visual_selection()
				else
					vim.notify("codex.send_visual_selection is unavailable", vim.log.levels.WARN)
				end
			end,
			"Send selection to Codex",
			opts = { silent = true },
		},
	},
}

-- Undotree
M.undotree = {
	plugin = true,

	n = {
		["<leader>u"] = {
			function()
				vim.cmd.UndotreeToggle()
			end,
			"Toggle UndoTree",
		},
	},
}

-- Vimtex
M.vimtex = {
	plugin = true,

	n = {
		["<leader>ll"] = { "<cmd>VimtexCompile<CR>", "Vimtex:compile" },
		["<leader>lv"] = { "<cmd>VimtexView<CR>", "Vimtex: openPDF" },
		["<leader>lc"] = { "<cmd>VimtexClean<CR>", "Vimtex: cleanbuild files" },
		["<leader>le"] = { "<cmd>VimtexErrors<CR>", "Vimtex: toggleerrors list" },
	},
}
return M
