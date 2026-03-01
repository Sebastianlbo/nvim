return {
	"folke/todo-comments.nvim",
	lazy = false,
	dependencies = { "nvim-lua/plenary.nvim" },

	init = function()
		require("utils").load_mappings("todo_comments")
	end,
	opts = {
		signs = true,
		sign_priority = 2,
		keywords = {
			BUG = { icon = " ", color = "#FF8C00", alt = { "Bug", "bug" } },
			REVIEW = { icon = " ", color = "#4FC3F7", alt = { "review", "Review" } },
			DEEPREVIEW = { icon = " ", color = "#4FC3F7", alt = { "DEEP-REVIEW", "deep-review" } },
			PRREVIEW = { icon = " ", color = "#00FF00", alt = { "PR-REVIEW", "PR-Review", "pr-review" } },
			NEWCODE = {
				icon = " ",
				color = "#FF0000",
				alt = { "New-Code", "new-code", "newcode", "NEWCODE", "NEW-CODE" },
			},
		},
		highlight = {
			keyword = "fg",
			pattern = [[.*\#\s*(KEYWORDS)]],
		},
		search = {
			pattern = [=[(?i)\#\s*(KEYWORDS)]=],
		},
	},
}
