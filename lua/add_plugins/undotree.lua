return {
  "mbbill/undotree",

  lazy = false,

  init = function()
    require("utils").load_mappings("undotree")
  end,

  config = function()
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}
