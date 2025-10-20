return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      checkbox = {
        enabled = true,
      },
      render_modes = false,
      footnote = {
        enabled = true,
        icon = "󰯔 ",
        superscript = true,
        prefix = "",
        suffix = "",
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "markdownlint-cli2", "markdown-toc" } },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then
                return true
              end
            end
          end,
        },
        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == "markdownlint"
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
      },
      formatters_by_ft = {
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      },
    },
  },
  {
    "jakewvincent/mkdnflow.nvim",
    config = function()
      require("mkdnflow").setup({
        modules = {
          bib = true,
          buffers = true,
          conceal = true,
          cursor = true,
          folds = true,
          foldtext = true,
          links = true,
          lists = true,
          maps = true,
          paths = true,
          tables = true,
          yaml = false,
          cmp = false,
        },
        filetypes = { md = true, rmd = true, markdown = true },
        create_dirs = true,
        perspective = {
          priority = "first",
          fallback = "current",
          root_tell = false,
          nvim_wd_heel = false,
          update = false,
        },
        wrap = false,
        bib = {
          default_path = nil,
          find_in_root = true,
        },
        silent = false,
        cursor = {
          jump_patterns = nil,
        },
        links = {
          style = "markdown",
          name_is_source = false,
          conceal = false,
          context = 0,
          implicit_extension = nil,
          transform_implicit = false,
          transform_explicit = function(text)
            text = text:gsub(" ", "-")
            text = text:lower()
            text = os.date("%Y-%m-%d_") .. text
            return text
          end,
          create_on_follow_failure = true,
        },
        new_file_template = {
          use_template = false,
          placeholders = {
            before = {
              title = "link_title",
              date = "os_date",
            },
            after = {},
          },
          template = "# {{ title }}",
        },
        to_do = {
          symbols = { " ", "-", "X" },
          update_parents = true,
          not_started = " ",
          in_progress = "-",
          complete = "X",
        },
        foldtext = {
          object_count = true,
          object_count_icons = "emoji",
          object_count_opts = function()
            return require("mkdnflow").foldtext.default_count_opts()
          end,
          line_count = true,
          line_percentage = true,
          word_count = false,
          title_transformer = nil,
          separator = " · ",
          fill_chars = {
            left_edge = "⢾",
            right_edge = "⡷",
            left_inside = " ⣹",
            right_inside = "⣏ ",
            middle = "⣿",
          },
        },
        tables = {
          trim_whitespace = true,
          format_on_move = true,
          auto_extend_rows = false,
          auto_extend_cols = false,
          style = {
            cell_padding = 1,
            separator_padding = 1,
            outer_pipes = true,
            mimic_alignment = true,
          },
        },
        yaml = {
          bib = { override = false },
        },
        mappings = {
          MkdnEnter = { { "n", "v" }, "<leader>mr" },
          --MkdnTab = false,
          --MkdnSTab = false,
          --MkdnNextLink = { "n", "<Tab>" },
          --MkdnPrevLink = { "n", "<S-Tab>" },
          MkdnNextHeading = { "n", "]]" },
          MkdnPrevHeading = { "n", "[[" },
          MkdnGoBack = { "n", "<BS>" },
          MkdnGoForward = { "n", "<Del>" },
          --MkdnCreateLink = false, -- see MkdnEnter
          MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>mp" },
          --MkdnDestroyLink = { "n", "<M-CR>" },
          --MkdnTagSpan = { "v", "<M-CR>" },
          MkdnMoveSource = { "n", "<F2>" },
          --MkdnYankAnchorLink = { "n", "yaa" },
          --MkdnYankFileAnchorLink = { "n", "yfa" },
          MkdnIncreaseHeading = { "n", "<leader>mh+" },
          MkdnDecreaseHeading = { "n", "<leader>mh-" },
          MkdnToggleToDo = { { "n", "v" }, "<C-Space>" },
          --MkdnNewListItem = false,
          MkdnNewListItemBelowInsert = { "n", "<leader>mto" },
          MkdnNewListItemAboveInsert = { "n", "<leader>mtO" },
          --MkdnExtendList = false,
          MkdnUpdateNumbering = { "n", "<leader>mn" },
          --MkdnTableNextCell = { "i", "<Tab>" },
          --MkdnTablePrevCell = { "i", "<S-Tab>" },
          --MkdnTableNextRow = false,
          --MkdnTablePrevRow = { "i", "<M-CR>" },
          --MkdnTableNewRowBelow = { "n", "<leader>ir" },
          --MkdnTableNewRowAbove = { "n", "<leader>iR" },
          --MkdnTableNewColAfter = { "n", "<leader>ic" },
          --MkdnTableNewColBefore = { "n", "<leader>iC" },
          MkdnFoldSection = { "n", "<leader>mf" },
          MkdnUnfoldSection = { "n", "<leader>mF" },
        },
      })
    end,
  },
}
