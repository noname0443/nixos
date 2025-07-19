{ config, pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-font-patcher
    noto-fonts-color-emoji
  ];
}
