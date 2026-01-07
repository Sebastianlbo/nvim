return {
  "sindrets/diffview.nvim",

  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewFileHistory",
  },

  init = function()
    local ok, utils = pcall(require, "utils")
    if ok and utils.load_mappings then
      utils.load_mappings("diffview")
    end
  end,

  opts = {
    enhanced_diff_hl = true,
    use_icons = true,
    view = { merge_tool = { layout = "diff3_mixed" } },
    file_panel = { listing_style = "tree" },
    file_history_panel = { use_icons = true },
  },

  config = function(_, opts)
    local ok, diffview = pcall(require, "diffview")
    if not ok then return end
    diffview.setup(opts)

    local function normalize_highlights()
      local set_hl = vim.api.nvim_set_hl
      set_hl(0, "DiffviewNormal", { link = "Normal" })
      set_hl(0, "DiffviewEndOfBuffer", { link = "EndOfBuffer" })
      set_hl(0, "DiffviewCursorLine", { link = "CursorLine" })
      set_hl(0, "DiffviewWinSeparator", { link = "WinSeparator" })
      set_hl(0, "DiffviewStatusLine", { link = "StatusLine" })
      set_hl(0, "DiffviewStatuslineNC", { link = "StatusLineNC" })
    end

    normalize_highlights()

    local aug = vim.api.nvim_create_augroup("DiffviewOverrides", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = aug,
      callback = normalize_highlights,
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = aug,
      pattern = { "DiffviewFiles", "DiffviewFileHistory" },
      desc = "Close Diffview with <Esc>",
      callback = function(ev)
        vim.keymap.set("n", "<Esc>", "<cmd>DiffviewClose<CR>", {
          buffer = ev.buf,
          silent = true,
          desc = "Close Diffview",
        })
      end,
    })
  end,
}
