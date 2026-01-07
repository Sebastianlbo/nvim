return {
  "williamboman/mason.nvim",

  cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },

  opts = {
    ensure_installed = {
      "lua-language-server",
      "texlab",
      "basedpyright",
      "pyright",
      "json-lsp",
      "sqlls",
      "ruff",
      "terraform-ls",
      "yaml-language-server",
      "bash-language-server",
      "dockerfile-language-server",
    },
  },

  config = function(_, opts)
    require("mason").setup(opts)

    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    if not string.find(vim.env.PATH or "", mason_bin, 1, true) then
      vim.env.PATH = mason_bin .. ":" .. (vim.env.PATH or "")
    end

    vim.api.nvim_create_user_command("MasonInstallAll", function()
      if opts.ensure_installed and #opts.ensure_installed > 0 then
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end
    end, {})

    vim.g.mason_binaries_list = opts.ensure_installed
  end,
}
