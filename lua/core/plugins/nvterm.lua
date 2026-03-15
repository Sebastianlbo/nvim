return {
	"zbirenbaum/nvterm",
	opts = {
		behavior = {
			close_on_exit = false,
		},
		terminals = {
			type_opts = {
				float = {
					relative = "editor",
					row = 0.125,
					col = 0.125,
					width = 0.75,
					height = 0.75,
				},
			},
		},
	},
	init = function()
		require("utils").load_mappings("nvterm")
	end,
	config = function(_, opts)
		local ok, nvterm = pcall(require, "nvterm")
		if ok then
			nvterm.setup(opts or {})
		end
	end,
}
