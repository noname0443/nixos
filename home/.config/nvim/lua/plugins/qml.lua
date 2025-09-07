return {}

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig["qmlls"].setup({
        cmd = { 'qmlls' },
        filetypes = { 'qml', 'qmljs' },
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        qml = { "qmlformat" },
      },
      formatters = {
        qmlformat = {
  				command = "qmlformat",
  				args = {
  					 "--functions-spacing",
  					 "--objects-spacing",
  					 "--normalize",
  					 "--indent-width",
  					 "4",
  					 "$FILENAME",
  					},
  				},
      },
    },
    keys = {
      {
        "<C-d>",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "n",
        desc = "Format buffer",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      local set = {}
      for _, lang in ipairs(opts.ensure_installed) do set[lang] = true end
      set.qml = nil
      set.qmljs = true
      local list = {}
      for k, v in pairs(set) do if v then table.insert(list, k) end end
      opts.ensure_installed = list
    end,
  },
}
