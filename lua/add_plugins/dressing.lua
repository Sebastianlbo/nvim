return {
  "stevearc/dressing.nvim",

  event = "VeryLazy",

  opts = {
    input = {
      enabled = true,
      border = "rounded",
      relative = "cursor",
      anchor = "NW",
      row = 1,
      col = 0,
      prefer_width = 40,
      start_in_insert = true,
      win_options = {
        winblend = 0,
      },
    },
  },

  config = function(_, opts)
    require("dressing").setup(opts)
  end,
}
