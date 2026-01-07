return {
  "akinsho/bufferline.nvim",

  version = "*",

  event = "VeryLazy",

  opts = {
    options = {
      mode = "buffers",
      themable = true,
      diagnostics = false,
      show_close_icon = false,
      show_buffer_close_icons = false,
      always_show_bufferline = true,
      show_buffer_icons = false,
      indicator = {style = 'none'},
      separator_style = "thick",
      name_formatter = function(buf)
        local name = buf.name
        return name
      end,

      offsets = {
        {
          filetype = "NvimTree",
          text = function()
            local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
            return " " .. cwd .. " /"
          end,
          text_align = "left",
          separator = true,
          highlight = "Directory",
        },
      },
    },
  },

  config = function(_, opts)
    local ok, bufferline = pcall(require, "bufferline")
    if not ok then return end
    bufferline.setup(opts)

    -- Load related keymaps once bufferline is available
    local ok_utils, utils = pcall(require, "utils")
    if ok_utils and utils and utils.load_mappings then
      utils.load_mappings("tabufline")
    end
  end,
}
