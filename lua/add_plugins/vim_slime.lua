return {
  "jpalardy/vim-slime",

  lazy = false,

  init = function()
    require("utils").load_mappings("vim_slime")

    -- plugin globals
    vim.g.slime_target = "neovim"
    vim.g.slime_bracketed_paste = 0
    vim.g.slime_python_ipython = 1
  end,

  config = function(_, opts)
    require("nvim-web-devicons").setup(opts)
  end,
}
