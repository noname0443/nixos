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

    programs.bash.enable = true;
    programs.home-manager.enable = true;
    imports = [
        ./nvim.nix
        ./tmux.nix
    ]; 

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };
}
