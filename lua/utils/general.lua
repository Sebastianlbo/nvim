local M = {}

local fn = vim.fn

function M.echo(str)
  vim.cmd("redraw")
  vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

function M.setup_mason_path()
  local mason_bin = fn.stdpath("data") .. "/mason/bin"
  local tex_bins = {
    "/Library/TeX/texbin",
    "/usr/local/texlive/2025/bin/universal-darwin",
  }

  if fn.isdirectory(mason_bin) == 1 and not string.find(vim.env.PATH, mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
  end

  for _, tex_bin in ipairs(tex_bins) do
    if fn.isdirectory(tex_bin) == 1 and not string.find(vim.env.PATH, tex_bin, 1, true) then
      vim.env.PATH = tex_bin .. ":" .. vim.env.PATH
      break
    end
  end
end

return M
