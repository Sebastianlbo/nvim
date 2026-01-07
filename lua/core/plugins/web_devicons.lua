return {
  "nvim-tree/nvim-web-devicons",

  opts = function()
  end,

  config = function(_, opts)
    require("nvim-web-devicons").setup(opts)
  end,
}

