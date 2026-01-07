return {
  "goerz/jupytext.nvim",

  version = "0.2.0",

  lazy = false,

  ft = { "ipynb", "py" },

  config = function()
    local ok, jupytext = pcall(require, "jupytext")
    if not ok then return end
    jupytext.setup({
      format = "py:percent",
      update = true,
      autosync = true,
      sync_patterns = { "*.py", "*.md" },
      handle_url_schemes = true,
    })
  end,
}

