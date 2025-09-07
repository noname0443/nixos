-- lua/plugins/avante.lua
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = (vim.fn.has("win32") ~= 0)
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",  -- downloads prebuilt binary; no cargo
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- comment render-markdown out for now; it often causes the sidebar crash if its deps/parsers aren't ready
      -- "MeanderingProgrammer/render-markdown.nvim",
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim",
    },
    opts = {
      -- turn off the parts that hook TextChangedI / sidebar updates
      windows = { sidebar = { enabled = true } },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        debounce = 250,
      },
      provider = "openai",
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-4.1-mini",
          timeout = 30000,
          temperature = 1,
        },
      },
    },
    config = function(_, opts)
      require("avante").setup(opts)
    end,
  },
}
