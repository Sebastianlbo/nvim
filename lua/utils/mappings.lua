local merge_tb = vim.tbl_deep_extend

local M = {}

function M.load_mappings(section, mapping_opt)
  vim.schedule(function()
    local mappings_src = _G.mappings or mappings
    local function set_section_map(section_values)
      if section_values.plugin then
        return
      end

      section_values.plugin = nil

      for mode, mode_values in pairs(section_values) do
        local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
        for keybind, mapping_info in pairs(mode_values) do
          local opts = merge_tb("force", default_opts, mapping_info.opts or {})

          mapping_info.opts, opts.mode = nil, nil
          opts.desc = mapping_info[2]

          vim.keymap.set(mode, keybind, mapping_info[1], opts)
        end
      end
    end

    if type(section) == "string" then
      local sect_tbl = mappings_src and mappings_src[section]
      if not sect_tbl then
        return
      end
      sect_tbl["plugin"] = nil
      mappings_src = { sect_tbl }
    end

    for _, sect in pairs(mappings_src or {}) do
      set_section_map(sect)
    end
  end)
end

return M
