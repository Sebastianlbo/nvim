return {
  "lewis6991/gitsigns.nvim",

  init = function()
    require("utils").load_mappings("gitsigns")
  end,

  event = { "BufReadPre", "BufNewFile" },

  dependencies = { "nvim-lua/plenary.nvim" },

  opts = function()
    local opts = {}

    opts.signs = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    }

    opts.signs_staged_enable = true
    opts.signcolumn = true
    opts.numhl = false
    opts.linehl = false
    opts.word_diff = false
    opts.attach_to_untracked = true
    opts.current_line_blame = false

    opts.current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 300,
      ignore_whitespace = false,
    }

    opts.current_line_blame_formatter = "<author>, <author_time:%R> • <summary>"

    opts.preview_config = {
      border = "double",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    }
    return opts
  end,

  config = function(_, opts)
    local gitsigns = require("gitsigns")
    gitsigns.setup(opts)

    local esc_group = vim.api.nvim_create_augroup("GitsignsDiffEsc", { clear
= true })

    local function esc_handler(win)
      if vim.v.hlsearch == 1 then
        vim.cmd.nohlsearch()
        return
      end

      local closed = false
      for _, target in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(target)
        if vim.api.nvim_buf_get_name(buf):match("^gitsigns://") then
          pcall(vim.api.nvim_win_close, target, true)
          closed = true
        end
      end

      if closed or vim.api.nvim_get_option_value("diff", { scope = "local", win
= win }) then
        vim.schedule(function()
          vim.cmd("diffoff!")
        end)
      end
    end

    vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
      group = esc_group,
      callback = function(evt)
        local win = vim.api.nvim_get_current_win()
        local in_diff = vim.api.nvim_get_option_value("diff", { scope =
"local", win = win })

        if not in_diff then
          local name = vim.api.nvim_buf_get_name(evt.buf)
          if name:match("^gitsigns://") then
            pcall(vim.keymap.del, "n", "<Esc>", { buffer = evt.buf })
          end
          return
        end

        vim.keymap.set("n", "<Esc>", function()
          esc_handler(win)
        end, { buffer = evt.buf, silent = true })
      end,
    })
    end,
}
