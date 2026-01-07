return {
  "neovim/nvim-lspconfig",

  event = { "BufReadPre", "BufNewFile" },

  dependencies = { "williamboman/mason.nvim", "hrsh7th/nvim-cmp", "github/copilot.vim" },

  --------------------------------------------------------
  ----------------  General Options  ---------------------
  --------------------------------------------------------
  opts = {
    diagnostics = {
      underline = true,
      severity_sort = true,
      float = {
        border = "double",
        source = "if_many",
        focusable = true,
        header = "Diagnostics:",
        prefix = "‣",
      },
      virtual_text = {
        spacing = 2,
        prefix = "‣",
        severity = { min = vim.diagnostic.severity.HINT },
        source = false,
      },
      signs = false,
    },

    --------------------------------------------------------
    --------------------  Servers  -------------------------
    --------------------------------------------------------
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            hint = { enable = true },
            telemetry = { enable = false },
          },
        },
      },

      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoImportCompletions = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
              inlayHints = {
                variableTypes = true,
                functionReturnTypes = true,
                callArgumentNames = "all",
              },
            },
          },
        },
      },

      texlab = {
        settings = {
          texlab = {
            build = {
              executable = "latexmk",
              args = {
                "-pdf",
                "-interaction=nonstopmode",
                "-synctex=1",
                "%f",
              },
              onSave = true,
              forwardSearchAfter = false,
            },

            forwardSearch = {
              executable = "Skim",
              args = { "--synctex-forward", "%l:1:%f", "%p" },
            },

            lint = {
              onChange = true,
            },

            chktex = {
              onOpenAndSave = true,
              onEdit = false,
            },

            diagnosticsDelay = 300,
            latexFormatter = "latexindent",
            latexindent = {
              modifyLineBreaks = true,
            },
          },
        },
      },

      jsonls = {},
      sqlls = {},
      terraformls = {},
      yamlls = {},
      bashls = {},
      dockerls = {},
    },
  },

  --------------------------------------------------------
  ----------------------  Init  --------------------------
  --------------------------------------------------------

  init = function() end,

  --------------------------------------------------------
  ---------------------  Config  -------------------------
  --------------------------------------------------------

  config = function(_, opts)
    local caps = vim.lsp.protocol.make_client_capabilities()

    local ok, cmp = pcall(require, "cmp_nvim_lsp")
    if ok then
      caps = cmp.default_capabilities(caps)
    end

    caps.general = caps.general or {}
    caps.general.positionEncodings = { "utf-16" }
    caps.offsetEncoding = { "utf-16" }

    local on_attach = function(_, bufnr)
      require("utils").load_mappings("lspconfig", { buffer = bufnr })

      vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })

      vim.keymap.set("n", "<leader>lx", function()
        vim.fn.jobstart({ "ruff", "check", "--fix", vim.fn.expand("%") })
      end, { desc = "Ruff: Fix file" })

      vim.keymap.set("n", "<leader>ltd", function()
        local current = vim.diagnostic.config().virtual_text
        local new_value = not current
        vim.diagnostic.config({ virtual_text = new_value })
        local msg = new_value and "Inline diagnostics ON" or "Inline diagnostics OFF"
        vim.notify(msg, vim.log.levels.INFO, { title = "Diagnostics" })
      end, { desc = "Toggle inline diagnostics" })
    end

    vim.diagnostic.config(opts.diagnostics or {})

    for name, cfg in pairs(opts.servers or {}) do
      cfg = vim.tbl_deep_extend("force", { on_attach = on_attach, capabilities = caps }, cfg or {})
      if cfg.caps and not cfg.capabilities then
        cfg.capabilities = cfg.caps
        cfg.caps = nil
      end
      vim.lsp.config(name, cfg)
      vim.lsp.enable(name)
    end
  end,
}
