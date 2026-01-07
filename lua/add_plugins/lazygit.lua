return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  init = function()
    require("utils").load_mappings("lazygit")
  end,

  config = function()
    vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window (0-100)
    vim.g.lazygit_floating_window_scaling_factor = 1.0 -- scaling factor for floating window
    vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- customize lazygit popup window border characters
    vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
    vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed
    vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1
    vim.g.lazygit_config_file_path = {} -- table of custom config file paths

    -- Let LazyGit receive raw <Esc> so it matches the standalone UX
    local esc_group = vim.api.nvim_create_augroup("LazyGitEscPassthrough", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "lazygit",
      group = esc_group,
      callback = function(args)
        vim.keymap.set("t", "<Esc>", "<Esc>", {
          buffer = args.buf,
          silent = true,
          desc = "LazyGit: allow Esc to reach the terminal",
        })
      end,
    })
  end,
}
