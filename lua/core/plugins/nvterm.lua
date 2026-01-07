return {
  "zbirenbaum/nvterm",
  opts = {
    behavior = {
      close_on_exit = false,
    },
  },
  init = function()
    require("utils").load_mappings("nvterm")
  end,
  config = function(_, opts)
    local ok, nvterm = pcall(require, "nvterm")
    if ok then
      nvterm.setup(opts or {})
    end
  end,
}
