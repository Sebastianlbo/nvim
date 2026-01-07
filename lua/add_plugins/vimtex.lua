return {
  "lervag/vimtex",

  lazy = true,

  ft = { "tex", "plaintex" },

  init = function()
    vim.g.vimtex_syntax_enabled = 0
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_view_skim_sync = 1
    vim.g.vimtex_view_skim_reading_bar = 1
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-pdf",
        "-interaction=nonstopmode",
        "-synctex=1",
        "-shell-escape",
      },
    }
    vim.g.vimtex_quickfix_mode = 0
  end,

  config = function(_, opts)
    require("which-key").setup(opts or {})

    local aug = vim.api.nvim_create_augroup("VimtexKeymaps", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
      group = aug,
      pattern = { "tex", "plaintex" },
      callback = function(args)
        require("utils").load_mappings("vimtex", { buffer = args.buf })
      end,
    })
  end,
}
