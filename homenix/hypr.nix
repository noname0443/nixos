{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    pyprland
    hyprlock
    hyprpaper

    kitty
    cool-retro-term

    starship
    waybar
    dunst
    libnotify

    qutebrowser
    zathura
    mpv
    imv
  ];
}
