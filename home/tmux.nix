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

    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      set -g mouse on
      set -g @catppuccin_flavour 'mocha'
    '';
  };
}
