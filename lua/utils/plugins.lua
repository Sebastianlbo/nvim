local M = {}

local fn = vim.fn

function M.build_plugin_list(names, opts)
  local function split_names(str)
    local out = {}
    for part in string.gmatch(str or "", "[^,%s]+") do
      table.insert(out, part)
    end
    return out
  end

  local function discover_names()
    local results, seen = {}, {}

    local patterns = {
      "lua/add_plugins/*.lua",
      "lua/core/plugins/*.lua",
    }
    local files = {}
    for _, pat in ipairs(patterns) do
      local hits = fn.globpath(vim.o.rtp, pat, true, true)
      for _, f in ipairs(hits or {}) do
        table.insert(files, f)
      end
    end

    for _, f in ipairs(files) do
      local name = f:match("([^/\\]+)%.lua$")
      if name and name ~= "lazy_nvim" and not seen[name] then
        seen[name] = true
        table.insert(results, name)
      end
    end

    table.sort(results)
    return results
  end

  local function exclude_names(all_names, excluded)
    if not excluded or #excluded == 0 then
      return all_names
    end
    local result = {}
    local skip = {}
    for _, n in ipairs(excluded) do
      skip[n] = true
    end
    for _, n in ipairs(all_names) do
      if not skip[n] then
        table.insert(result, n)
      end
    end
    return result
  end

  local resolved_names
  if names == nil then
    resolved_names = discover_names()
  elseif type(names) == "string" then
    resolved_names = split_names(names)
  elseif type(names) == "table" then
    resolved_names = names
  else
    error("build_plugin_list: unsupported names type: " .. type(names))
  end

  if opts and opts.exclude then
    resolved_names = exclude_names(resolved_names, opts.exclude)
  end

  local list = {}

  local include_plenary = true
  if opts and opts.include_plenary ~= nil then
    include_plenary = opts.include_plenary
  end
  if include_plenary then
    table.insert(list, "nvim-lua/plenary.nvim")
  end

  for _, name in ipairs(resolved_names or {}) do
    local loaded, spec

    loaded, spec = pcall(require, "core.plugins." .. name)
    if not loaded then
      loaded, spec = pcall(require, "add_plugins." .. name)
    end

    if not loaded then
      error(
        "Unable to resolve plugin module for: "
          .. name
          .. " (tried plugins."
          .. name
          .. ", core.plugins."
          .. name
          .. ", add_plugins."
          .. name
          .. ")"
      )
    end

    table.insert(list, spec)
  end

  return list
end

return M
