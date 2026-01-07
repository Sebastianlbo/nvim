return {
  "folke/todo-comments.nvim",
  event = "VimEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = true,
    sign_priority = 2,
    search = {
      pattern = [[\#\s*\b(KEYWORDS):]],
    },
  },
}
