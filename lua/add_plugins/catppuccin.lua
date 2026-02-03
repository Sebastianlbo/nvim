return {
	"catppuccin/nvim",

	name = "catppuccin",

	lazy = false,

	priority = 1000,

	opts = {
		flavour = "mocha",
		integrations = {
			diffview = true,
			treesitter = true,
			native_lsp = { enabled = true },
			nvimtree = true,
			cmp = true,
			bufferline = true,
		},

		color_overrides = {
			mocha = {
				base = "#0B0B12",
				orange = "orange",
				-- rosewater = "#f5e0dc",
				-- flamingo  = "#f2cdcd",
				-- pink      = "#f5c2e7",
				-- mauve     = "#cba6f7",
				-- red       = "#f38ba8",
				-- peach     = "#fab387",
				-- yellow    = "#f9e2af",
				-- green     = "#a6e3a1",
				-- teal      = "#94e2d5",
				-- sky       = "#89dceb",
				-- sapphire  = "#74c7ec",
				-- blue      = "#89b4fa",
				-- lavender  = "#b4befe",
				-- text      = "#cdd6f4",
				-- subtext1  = "#bac2de",
				-- surface0  = "#313244",
				-- mantle    = "#181825",
				-- crust     = "#11111b",
			},
		},

		custom_highlights = function(colors)
			return {
				--Alpha
				AlphaHeader = { fg = colors.peach },
				AlphaKeyHint = { fg = colors.blue },
				AlphaFooter = { fg = colors.peach },

				-- Bufferline
				BufferLineFill = { bg = colors.base },
				BufferLineBackground = { fg = "#C2C2C4", bg = colors.base },
				BufferLineBuffer = { fg = colors.base, bg = colors.base },
				BufferLineBufferVisible = { fg = colors.blue, bg = colors.base },
				BufferLineBufferSelected = { fg = colors.blue, bg = colors.base },
				BufferLineSeparator = { fg = colors.blue, bg = colors.base },
				BufferLineSeparatorVisible = { fg = colors.surface0, bg = colors.base },
				BufferLineSeparatorSelected = { fg = colors.blue, bg = colors.base },

				BufferLineIndicatorSelected = { fg = colors.blue, bg = colors.base },
				BufferLineIndicatorVisible = { fg = colors.surface0, bg = colors.base },
				BufferLineCloseButton = { fg = colors.surface1, bg = colors.base },
				BufferLineCloseButtonVisible = { fg = colors.surface1, bg = colors.base },
				BufferLineCloseButtonSelected = { fg = colors.blue, bg = colors.base },
				BufferLineModified = { fg = colors.yellow, bg = colors.base },
				BufferLineModifiedVisible = { fg = colors.yellow, bg = colors.base },
				BufferLineModifiedSelected = { fg = colors.yellow, bg = colors.base },
				BufferLineTab = { fg = colors.surface1, bg = colors.base },
				BufferLineTabSelected = { fg = colors.text, bg = colors.base },
				BufferLineTabClose = { fg = colors.surface1, bg = colors.base },
				BufferLineOffsetSeparator = { fg = colors.surface0, bg = colors.base },

				-- Split separators
				WinSeparator = { fg = colors.blue, bg = colors.base, bold = true },

				-- Visual selection
				Visual = { bg = colors.surface0 },

				-- Search
				Search = { fg = colors.mantle, bg = colors.yellow, bold = true },
				CurSearch = { fg = colors.mantle, bg = colors.orange, bold = true },
				IncSearch = { fg = colors.mantle, bg = colors.orange, bold = true },

				-- NvimTree git colors to match shell theme
				NvimTreeGitDirty = { fg = colors.peach },
				NvimTreeGitStaged = { fg = colors.yellow },
				NvimTreeGitNew = { fg = colors.green },

				-- Make UI transparent as in nvim config
				Normal = { bg = "NONE" },
				NormalNC = { bg = "NONE" },
				NormalFloat = { bg = "NONE" },
				FloatBorder = { bg = "NONE" },
				VertSplit = { bg = "NONE" },
				SignColumn = { bg = "NONE" },
				FoldColumn = { bg = "NONE" },
				LineNr = { bg = "NONE" },
				StatusLine = { fg = colors.text, bg = colors.base },
				StatusLineNC = { fg = colors.surface1, bg = colors.base },

				-- Prefer transparent file tree to match overall transparency
				NvimTreeNormal = { bg = "NONE" },
				NvimTreeNormalNC = { bg = "NONE" },
				NvimTreeEndOfBuffer = { bg = "NONE" },

				LspSignatureActiveParameter = { fg = colors.crust, bg = colors.green },
			}
		end,
	},

	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
