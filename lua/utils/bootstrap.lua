local general = require("utils.general")

local M = {}

local fn = vim.fn

local function shell_call(args)
  local output = fn.system(args)
  assert(vim.v.shell_error == 0, "External call failed with error code: " .. vim.v.shell_error .. "\n" .. output)
end

function M.lazy(install_path)
  general.echo("  Installing lazy.nvim & plugins ...")
  local repo = "https://github.com/folke/lazy.nvim.git"
  if fn.isdirectory(install_path) ~= 1 then
    shell_call({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, install_path })
  end
  vim.opt.rtp:prepend(install_path)

  require("plugins.plugins")
end

return M
