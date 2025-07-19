{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    plugins = [
      pkgs.tmuxPlugins.better-mouse-mode
      pkgs.tmuxPlugins.catppuccin
      pkgs.tmuxPlugins.sensible
      pkgs.tmuxPlugins.vim-tmux-navigator
    ];
  };
}
