return {
  "nvim-telescope/telescope.nvim",

  branch = "master",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/nvterm",
  },

  cmd = "Telescope",

  init = function()
    require("utils").load_mappings("telescope")
  end,

  opts = function()
    local actions = require("telescope.actions")
    return {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = { prompt_position = "bottom", preview_width = 0.6 },
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.preview_scrolling_down,
          },
          n = {
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.preview_scrolling_down,
          },
        },
        file_ignore_patterns = { "node_modules", "%.git", ".venv" },
        path_display = { filename_first = { reverse_directories = false } },
      },
      pickers = {

        oldfiles = {
          initial_mode = "insert",
          cwd_only = true,
          only_cwd = true,
        },

        find_files = {
          initial_mode = "insert",
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--no-ignore",
            "--follow",
            "-g",
            "!**/.git/*",
          },
          only_cwd = true,
        },

        live_grep = {
          additional_args = function()
            return {
              "--hidden",
              "--no-ignore",
              "--follow",
              "-g",
              "!**/.git/*",
            }
          end,
        },

        buffers = {
          initial_mode = "insert",
          sort_lastused = true,
          mappings = { n = { ["d"] = actions.delete_buffer } },
        },

        diagnostics = {
          initial_mode = "normal",
        },

        marks = { initial_mode = "insert" },
        git_files = { previewer = false },
      },

      extensions = {
        ["ui-select"] = require("telescope.themes").get_dropdown(),
      },
      extensions_list = { "fzf", "ui-select", "terms" },
    }
  end,

  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    for _, ext in ipairs(opts.extensions_list or {}) do
      pcall(telescope.load_extension, ext)
    end

    local api = vim.api
    local builtin = require("telescope.builtin")

    local function switch_picker(kind)
      pcall(vim.cmd, "stopinsert") -- leave insert mode if prompt was focused
      pcall(vim.cmd, "close")   -- close current Telescope window
      if kind == "files" then
        builtin.find_files()
      else
        builtin.live_grep()
      end
    end

    local function set_telescope_normal_mappings(bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "f", function()
        switch_picker("files")
      end, opts)
      vim.keymap.set("n", "w", function()
        switch_picker("grep")
      end, opts)
    end

    api.nvim_create_autocmd("FileType", {
      pattern = { "TelescopePrompt", "TelescopeResults" },
      callback = function(args)
        set_telescope_normal_mappings(args.buf)
      end,
    })
  end,
}
