{ config, pkgs, ... }:
{
 programs.nixvim = {
      opts = {
        number = true;
        relativenumber = true;

	   
      expandtab = true;
        autoindent = true;
        smartindent = true;

        shiftwidth = 4;
        softtabstop = 4;
        tabstop = 4;

        termguicolors = true;
      };

      keymaps = [
        {
          key = "<C-s>";
          action = "<cmd>w<cr><esc>";
        }
      ];

      extraPackages = with pkgs; [
        lua-language-server
	    gopls
	    gofumpt
        stylua
        ripgrep
        go
        golangci-lint
      ];

      enable = true;

      colorschemes.catppuccin.enable = true;
      plugins.lualine.enable = true;
      plugins.neo-tree.enable = true;
      plugins.web-devicons.enable = true;
      plugins.mini.enable = true;

      plugins.cmp = {
        enable = true;
        settings = {
          preselect = "cmp.PreselectMode.Item";
          mapping = {
            "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-e>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-r>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Esc>" = "close";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.confirm({ select = true })";
          };
          autoEnableSources = true;
          sources = [
            {name = "path";}
            {
              name = "nvim_lsp";
              keywordLength = 1;
            }
            {
              name = "buffer";
              keywordLength = 3;
            }
          ];
	    };
      };

      clipboard.providers.wl-copy.enable = true;

      plugins.cmp-nvim-lsp.enable = true;
      plugins.cmp-buffer.enable = true;
      plugins.cmp-path.enable = true;
      plugins.cmp-treesitter.enable = true;

      plugins.lsp = {
        inlayHints = true;
        enable = true;
        servers.gopls = {
          enable = true;
          extraOptions = {
            settings.gopls = {
              gofumpt = true;
              codelenses = {
                gc_details = false;
                generate = true;
                regenerate_cgo = true;
                run_govulncheck = true;
                test = true;
                tidy = true;
                upgrade_dependency = true;
                vendor = true;
              };
              hints = {
                assignVariableTypes = true;
                compositeLiteralFields = true;
                compositeLiteralTypes = true;
                constantValues = true;
                functionTypeParameters = true;
                parameterNames = true;
                rangeVariableTypes = true;
              };
              analyses = {
                nilness = true;
                unusedparams = true;
                unusedwrite = true;
                useany = true;
              };
              usePlaceholders = true;
              completeUnimported = true;
              staticcheck = true;
            };
          };
        };
      };

      plugins.treesitter = {
        enable = true;
        ensureInstalled = [ "go" "gomod" "gowork" "gosum" ];
      };
    }; 
}
