return {
  "nvim-tree/nvim-tree.lua",

  cmd = { "NvimTreeToggle", "NvimTreeFocus" },

  init = function()
    require("utils").load_mappings("nvimtree")
  end,

  opts = {
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.set("n", "<Esc>", function()
        if vim.v.hlsearch == 1 then
          vim.cmd("nohlsearch")
          return
        end
        api.tree.close()
      end, { buffer = bufnr, silent = true, desc = "Clear highlight or close nvim-tree" })
    end,

    filters = {
      dotfiles = false,
      exclude = { vim.fn.stdpath("config") .. "/lua/custom" },
    },
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = true,
    update_focused_file = {
      enable = false,
      update_root = false,
    },
    view = {
      float = {
        enable = true,
        open_win_config = function()
          local screen_w = vim.opt.columns:get()
          local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
          local window_w = 120
          local window_h = 50
          local center_x = (screen_w - window_w) / 2
          local center_y = (screen_h - window_h) / 2
          return {
            relative = "editor",
            border = "rounded",
            width = window_w,
            height = window_h,
            row = center_y,
            col = center_x,
          }
        end,
      },
    },
    git = {
      enable = true,
      ignore = false,
    },
    filesystem_watchers = {
      enable = true,
    },
    actions = {
      open_file = {
        resize_window = true,
      },
    },
    renderer = {
      root_folder_label = false,
      highlight_git = true,
      highlight_opened_files = "none",

      indent_markers = {
        enable = false,
      },

      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },

        glyphs = {
          default = "󰈚",
          symlink = "",
          folder = {
            default = "",
            empty = "",
            empty_open = "",
            open = "",
            symlink = "",
            symlink_open = "",
            arrow_open = "",
            arrow_closed = "",
          },
          git = {
            unstaged = "",
            staged = "",
            unmerged = "",
            renamed = "➜",
            untracked = "",
            deleted = "",
            ignored = "◌",
          },
        },
      },
    },
  },

  config = function(_, opts)
    require("nvim-tree").setup(opts)

    local function set_gitignored_grey()
      local grey = "#6e6e6e"
      pcall(vim.api.nvim_set_hl, 0, "NvimTreeGitIgnored", { fg = grey, italic = true })
      pcall(vim.api.nvim_set_hl, 0, "NvimTreeGitIgnoredIcon", { fg = grey })
    end
    set_gitignored_grey()

    -- re-apply if your colorscheme reloads (themes often reset groups)
    local grp = vim.api.nvim_create_augroup("NvimTreeGitIgnoredHL", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = grp,
      callback = set_gitignored_grey,
    })
  end,
}
