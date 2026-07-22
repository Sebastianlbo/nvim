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
		["<A-BS>"] = { "<C-w>", "Delete previous word" },

		["<C-Esc>"] = { "<Esc>", "Enter normal mode" },
	},

	n = {
		["<Space>"] = { "<Nop>", "Disabled (reserved for leader)", silent = true },
		["<BS>"] = { "<Nop>", "Disabled in normal mode", silent = true },
		["<leader>y"] = { "<Nop>", "Disabled", silent = true },
		["<leader>cc"] = { "<Nop>", "Disabled", silent = true },
		["q:"] = { ":q", "Disable command history window" },

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

		-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
		-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
		["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
		["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },

		["yc"] = {
			function()
				local line = vim.api.nvim_get_current_line()
				local row = vim.api.nvim_win_get_cursor(0)[1]
				vim.api.nvim_buf_set_lines(0, row, row, false, { line })
				require("Comment.api").toggle.linewise.current()
			end,
			"Duplicate line and comment original",
		},

		["<leader>li"] = {
			function()
				local word = vim.fn.expand("<cword>")
				if word == "" then
					vim.notify("No word under cursor", vim.log.levels.WARN)
					return
				end
				local row = vim.api.nvim_win_get_cursor(0)[1]
				local indent = vim.api.nvim_get_current_line():match("^(%s*)")
				local lines = {
					indent .. "logger.debug(",
					indent
						.. '    "\\n\\nSTART=================================================================================\\n"',
					indent
						.. '    + "--------------------------------------------------------------------------------------\\n\\n"',
					indent .. '    + f"' .. word .. " : {" .. word .. '}"',
					indent
						.. '    + "\\n\\n--------------------------------------------------------------------------------------\\n"',
					indent
						.. '    + "===================================================================================END\\n\\n"',
					indent .. ")",
				}
				vim.api.nvim_buf_set_lines(0, row, row, false, lines)
			end,
			"Insert logger.debug block for word under cursor",
		},

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
		["<Esc>"] = { "<C-\\><C-N>", "Escape terminal mode" },
		["<C-Esc>"] = { "<C-\\><C-N>", "Enter normal mode" },
	},

	v = {
		["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
		["<"] = { "<gv", "Dedent selection" },
		[">"] = { ">gv", "Indent selection" },
		["<leader>rw"] = {
			"y:%s/<C-r>0//gc<Left><Left><Left>",
			"Substitute selection everywhere with confirm",
		},

		-- Move selected line / block of text in visual mode
		["J"] = { ":m '>+1<CR>gv=gv", "Move selection down", opts = { noremap = true } },
		["K"] = { ":m '<-2<CR>gv=gv", "Move selection up", opts = { noremap = true } },

		["<C-Esc>"] = { "<Esc>", "Enter normal mode" },

		["<leader>li"] = {
			function()
				local word = vim.fn.getreg("0")
				local row = vim.api.nvim_win_get_cursor(0)[1]
				local indent = vim.api.nvim_get_current_line():match("^(%s*)")
				local lines = {
					indent .. "logger.debug(",
					indent
						.. '    "\\n\\nSTART=================================================================================\\n"',
					indent
						.. '    + "--------------------------------------------------------------------------------------\\n\\n"',
					indent .. '    + f"' .. word .. " : {" .. word .. '}"',
					indent
						.. '    + "\\n\\n--------------------------------------------------------------------------------------\\n"',
					indent
						.. '    + "===================================================================================END\\n\\n"',
					indent .. ")",
				}
				vim.api.nvim_buf_set_lines(0, row, row, false, lines)
				vim.api.nvim_feedkeys("x", "n", false)
			end,
			"Insert logger.info debug block",
		},
	},

	x = {
		["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
		["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		-- Don't copy the replaced text after pasting in visual mode
		-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
		["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "Paste without overwriting yank register", opts = { silent = true } },

		["<C-Esc>"] = { "<Esc>", "Enter normal mode" },
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

		["<leader>df"] = {
			function()
				vim.diagnostic.open_float()
			end,
			"Floating diagnostic",
		},

		["<leader>dp"] = {
			function()
				vim.diagnostic.goto_prev({ float = { border = "rounded" } })
			end,
			"Goto prev diagnostic",
		},

		["<leader>dn"] = {
			function()
				vim.diagnostic.goto_next({ float = { border = "rounded" } })
			end,
			"Goto next diagnostic",
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

		["<leader>e"] = {
			function()
				local api = require("nvim-tree.api")
				if api.tree.is_visible() then
					api.tree.close()
				else
					if _G._nvimtree_mode ~= "float" then
						require("nvim-tree").setup(_G._nvimtree_base_opts or {})
						_G._nvimtree_mode = "float"
					end
					api.tree.open()
				end
			end,
			"Toggle nvim-tree float",
		},

		["<leader>o"] = {
			function()
				local api = require("nvim-tree.api")
				if api.tree.is_visible() then
					api.tree.close()
				else
					if _G._nvimtree_mode ~= "right" then
						local base = _G._nvimtree_base_opts or {}
						local right_opts = vim.tbl_deep_extend("force", base, {
							view = {
								side = "right",
								width = 40,
								float = { enable = false },
							},
						})
						require("nvim-tree").setup(right_opts)
						_G._nvimtree_mode = "right"
					end
					api.tree.open()
				end
			end,
			"Toggle nvim-tree right column",
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
		["_"] = {
			function()
				local hidden_terms = {}
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					if
						vim.api.nvim_buf_is_loaded(bufnr)
						and vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == "terminal"
						and vim.fn.buflisted(bufnr) == 0
					then
						vim.bo[bufnr].buflisted = true
						table.insert(hidden_terms, bufnr)
					end
				end
				require("telescope.builtin").buffers({ show_all_buffers = true })
				vim.schedule(function()
					for _, bufnr in ipairs(hidden_terms) do
						if vim.api.nvim_buf_is_valid(bufnr) then
							vim.bo[bufnr].buflisted = false
						end
					end
				end)
			end,
			"Telescope Buffers (all)",
		},
		["<leader>tt"] = {
			"<cmd>TodoTelescope keywords=BUG,REVIEW,DEEPREVIEW,NEW-CODE,PR-REVIEW<CR>",
			"Search custom todo keywords",
		},
		["<leader>tgc"] = { "<cmd>Telescope git_commits<CR>", "Telescope Git Commits" },
		["<leader>tgd"] = { "<cmd>Telescope git_status<CR>", "Telescope Git Diff" },
		["<leader>tgu"] = {
			function()
				require("telescope.builtin").find_files({
					find_command = { "git", "diff", "--name-only" },
					prompt_title = "Unstaged Files",
				})
			end,
			"Telescope Unstaged Files",
		},
		["<leader>tm"] = { "<cmd>Telescope marks<CR>", "Telescope Marks" },
		["<BS><leader>"] = { "<cmd>Telescope buffers show_all_buffers=true<CR>", "Telescope Buffers (all)" },
		["<leader><BS>"] = { "<cmd>Telescope buffers show_all_buffers=true<CR>", "Telescope Buffers (all)" },
		["<leader>th"] = { "<cmd>Telescope help_tags <CR>", "Help page" },
		["<leader>tM"] = {
			function()
				require("telescope.builtin").live_grep({
					prompt_title = "Search Mappings",
					search_dirs = { vim.fn.stdpath("config") .. "/lua/core/mappings.lua" },
				})
			end,
			"Search Mappings",
		},
		["<leader>tjj"] = {
			"<cmd>Telescope find_files follow=true no_ignore=true hidden=true <CR>",
			"Find Files (all)",
		},
		["<leader>tji"] = {
			function()
				require("telescope.builtin").find_files({
					find_command = { "rg", "--files", "--hidden", "--follow", "-g", "!**/.git/*" },
				})
			end,
			"Find Files (non-ignored)",
		},
		["<leader>to"] = { "<cmd>Telescope oldfiles<CR>", "Telescope Oldfiles" },
		["<leader>td"] = { "<cmd>Telescope diagnostics bufnr=0<CR>", "Telescope Diagnostics (current file)" },
		["<leader>tad"] = { "<cmd>Telescope diagnostics<CR>", "Telescope All Diagnostics" },
		["<leader>tww"] = {
			function()
				require("telescope.builtin").live_grep({
					additional_args = { "--no-ignore", "--hidden" },
				})
			end,
			"Live Grep (all)",
		},
		["<leader>twi"] = {
			function()
				require("telescope.builtin").live_grep({
					additional_args = { "--hidden", "--follow", "-g", "!**/.git/*" },
				})
			end,
			"Live Grep (non-ignored)",
		},
		["<leader>tx"] = {
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end,
			"Live grep in open buffers",
		},
		["<leader>t/"] = {
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(
					require("telescope.themes").get_dropdown({ previewer = false })
				)
			end,
			"Fuzzy find in current buffer",
		},
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
		["<leader>hn"] = {
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

		["<leader>hp"] = {
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

		["<leader>hr"] = {
			function()
				require("gitsigns").reset_hunk()
			end,
			"Hunk Restore",
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
		["<leader>gdm"] = { "<cmd>DiffviewOpen origin/main<CR>", "Git Diff vs origin/main" },
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

-- Claude Code
M.claudecode = {
	plugin = true,

	n = {
		["<leader>cv"] = { "<cmd>ClaudeCode<cr>", "Claude View Buffer Toggle" },
		["<leader>cf"] = { "<cmd>ClaudeCodeFocus<cr>", "Claude Focus" },
		["<leader>cr"] = { "<cmd>ClaudeCode --resume<cr>", "Claude Resume" },
		["<leader>cC"] = { "<cmd>ClaudeCode --continue<cr>", "Claude Continue" },
		["<leader>cm"] = { "<cmd>ClaudeCodeSelectModel<cr>", "Claude Model Select" },
	},

	v = {
		["<leader>cs"] = { "<cmd>ClaudeCodeSend<cr>", "Claude Send" },
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
		["<leader>ll"] = { "<cmd>VimtexCompile<CR>", "Vimtex: Compile" },
		["<leader>lv"] = { "<cmd>VimtexView<CR>", "Vimtex: Open PDF" },
		["<leader>lc"] = { "<cmd>VimtexClean<CR>", "Vimtex: Clean build files" },
		["<leader>le"] = { "<cmd>VimtexErrors<CR>", "Vimtex: Toggle errors list" },
	},
}
return M
