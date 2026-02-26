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
				snacks_win_opts = {},
			},
		})

		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "*claude*",
			callback = function(ev)
				vim.keymap.set("n", "<Esc>", "<cmd>ClaudeCode<CR>", { buffer = ev.buf, silent = true })
			end,
		})
	end,
}
