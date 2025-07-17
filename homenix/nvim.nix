{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lua
    luarocks

    gopls
    gofumpt
    ripgrep
  ];
  programs.neovim = {
    enable = true;
  };
}
