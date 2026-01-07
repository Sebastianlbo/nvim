return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",

  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      dependencies = "rafamadriz/friendly-snippets",
      opts = { history = true, updateevents = "TextChanged,TextChangedI" },
      config = function(_, opts)
        local luasnip = require("luasnip")
        luasnip.config.set_config(opts)
        local ok, loader = pcall(require, "luasnip.loaders.from_vscode")
        if ok and loader then
          loader.lazy_load()
        end
      end,
    },

    {
      "windwp/nvim-autopairs",
      opts = {
        fast_wrap = {},
        disable_filetype = { "TelescopePrompt", "vim" },
      },
      config = function(_, opts)
        require("nvim-autopairs").setup(opts)
        local ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
        if ok then
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
      end,
    },

    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lua" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
  },

  opts = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    return {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),

      window = {
        completion = cmp.config.window.bordered({
          border = "double",
          scrolloff = 2,
        }),
        documentation = cmp.config.window.bordered({
          border = "double",
        }),
      },

      completion = {
        autocomplete = { "InsertEnter", "TextChanged" },
        keyword_length = 2,
      },
      performance = { debounce = 60 },

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      },
      {
        { name = "buffer" },
        { name = "path" },
        { name = "nvim_lua" },
      }),
    }
  end,

  config = function(_, opts)
    require("cmp").setup(opts)
  end,
}
