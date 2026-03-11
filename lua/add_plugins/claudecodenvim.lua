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
		"ClaudeCodeDiffAccept",
		"ClaudeCodeDiffDeny",
	},

	init = function()
		require("utils").load_mappings("claudecode")
	end,

	config = function()
		require("claudecode").setup({
			terminal = {
				snacks_win_opts = {
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
		})

		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "*claude*",
			callback = function(ev)
				vim.keymap.set("n", "<Esc>", "<cmd>ClaudeCode<CR>", { buffer = ev.buf, silent = true })
				vim.keymap.set("t", "<C-Esc>", "<C-\\><C-N>", { buffer = ev.buf, silent = true })
			end,
		})
	end,
}
