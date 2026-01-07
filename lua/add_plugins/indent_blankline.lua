return {
  "lukas-reineke/indent-blankline.nvim",

  version = "2.20.7",

  event = { "BufReadPre", "BufNewFile" },

  opts = {
    show_current_context = true,
    show_trailing_blankline_indent = false,
  },

  init = function()
    require("utils").load_mappings("blankline")
  end,

  config = function(_, opts)
    require("indent_blankline").setup(opts)
  end,
}
