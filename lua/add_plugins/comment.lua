return {
  "numToStr/Comment.nvim",

  init = function()
    require("utils").load_mappings("comment")
  end,

  config = function(_, opts)
    require("Comment").setup(opts or {})
  end,
}
