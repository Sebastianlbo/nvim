return {
  "folke/which-key.nvim",

  lazy = false,

  keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },

  cmd = "WhichKey",

  init = function()
    require("utils").load_mappings("whichkey")
  end,

  config = function(_, opts)
    require("which-key").setup(opts or {})
  end,
}
