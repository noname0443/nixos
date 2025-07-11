{ config, pkgs, lib, nixvim, ... }:
{
  users.users.eugene = {
    isNormalUser = true;
    description = "Eugene";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager.users.eugene = { pkgs, nixvim, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    home.file.".config/hypr".source = ./hypr;
    home.file.".config/tmux".source = ./tmux;

    programs.bash.enable = true;
    imports = [
        ./nvim.nix
    ];
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
          mapping = {
            "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-e>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-r>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<CR>" = "confirm";
            "<Esc>" = "close";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete({ select = true })";
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
              hints = {
                assignVariableTypes = true;
                compositeLiteralFields = true;
                compositeLiteralTypes = true;
                constantValues = true;
                functionTypeParameters = true;
                parameterNames = true;
                rangeVariableTypes = true;
              };
            };
          };
        };
      };

      plugins.treesitter = {
        enable = true;
        ensureInstalled = [ "go" "gomod" "gowork" "gosum" ];
      };
    };

    home.file."./.tmux/plugins/tpm".source = builtins.fetchTarball {
      url =  "https://github.com/tmux-plugins/tpm/archive/refs/tags/v3.1.0.tar.gz";
      sha256 = "sha256:18i499hhxly1r2bnqp9wssh0p1v391cxf10aydxaa7mdmrd3vqh9";
    };
    # git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };
}
