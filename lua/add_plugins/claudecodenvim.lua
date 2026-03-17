return {
	"coder/claudecode.nvim",

	dependencies = { "folke/snacks.nvim" },

	cmd = {
		"ClaudeCode",
		"ClaudeCodeFocus",
		"ClaudeCodeSelectModel",
		"ClaudeCodeAdd",
		"ClaudeCodeSend",
		"ClaudeCodeTreeAdd",
	},

	opts = {
		terminal = {
			---@module "snacks"
			---@type snacks.win.Config|{}
			snacks_win_opts = {
				position = "float",
				row = 0.125,
				col = 0.125,
				width = 0.75,
				height = 0.75,
				border = "single",
				keys = {
					term_normal = {
						"<C-Esc>",
						function()
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true),
								"n",
								false
							)
						end,
						desc = "Enter Normal Mode",
						mode = "t",
					},
				},
			},
		},
	},

	init = function()
		require("utils").load_mappings("claudecode")
	end,

	config = function(_, opts)
		local tools = require("claudecode.tools.init")
		local original_register_all = tools.register_all
		tools.register_all = function()
			original_register_all()
			tools.tools["openDiff"] = nil
		end

		require("claudecode").setup(opts)

		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "*claude*",
			callback = function(ev)
				vim.keymap.set("n", "<Esc>", "<cmd>ClaudeCode<CR>", { buffer = ev.buf, silent = true })
				vim.keymap.set("t", "<C-Esc>", "<C-\\><C-N>", { buffer = ev.buf, silent = true })

				local approval_patterns = {
					"do you want to proceed",
					"do you want to make this edit",
					"to make?",
					"you like?",
					"allow",
					"bug",
					"review",
					"deepreview",
					"new%-code",
					"pr%-review",
				}

				vim.api.nvim_buf_attach(ev.buf, false, {
					on_lines = function(_, bufnr, _, first_line, last_line)
						local lines = vim.api.nvim_buf_get_lines(bufnr, first_line, last_line, false)
						for _, line in ipairs(lines) do
							for _, pat in ipairs(approval_patterns) do
								if line:lower():match(pat) then
									vim.schedule(function()
										vim.notify("Claude Code needs your approval!", vim.log.levels.WARN, {
											title = "Claude Code",
										})
									end)
									return
								end
							end
						end
					end,
				})
			end,
		})
	end,
}
