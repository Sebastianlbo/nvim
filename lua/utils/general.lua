local M = {}

local fn = vim.fn

function M.echo(str)
  vim.cmd("redraw")
  vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

function M.setup_mason_path()
  local mason_bin = fn.stdpath("data") .. "/mason/bin"

  if fn.isdirectory(mason_bin) == 1 and not string.find(vim.env.PATH, mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
  end
end

return M
