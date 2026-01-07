return {
  "chentoast/marks.nvim",

  event = "VeryLazy",
  
  opts = {
    signs = false,
    default_mappings = true,
    builtin_marks = { ".", "<", ">", "^" },
    cyclic = true,
    force_write_shada = false,
    bookmark_0 = { sign = "⚑" },
    excluded_filetypes = { "NvimTree", "alpha", "toggleterm" },
  },
}

