local general = require("utils.general")
local bootstrap = require("utils.bootstrap")
local mappings = require("utils.mappings")
local plugins = require("utils.plugins")
local dashboard = require("utils.dashboard")

local M = {}
local modules = { general, bootstrap, mappings, plugins }

for _, mod in ipairs(modules) do
  for key, value in pairs(mod) do
    M[key] = value
  end
end

M.ui = dashboard

return M
