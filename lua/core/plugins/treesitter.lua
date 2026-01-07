return {
  "nvim-treesitter/nvim-treesitter",

  event = { "BufReadPost", "BufNewFile" },

  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },

  build = ":TSUpdate",

  opts = {
    ensure_installed = { "bibtex", "latex", "markdown", "markdown_inline" },
    highlight = { enable = true },
    indent = { enable = true },
  },

  config = function(_, opts)
    require("nvim-treesitter").setup(opts)
  end,
}

