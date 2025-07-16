{ config, pkgs, lib, ... }:
{
  imports = [
    ./nvim.nix
    ./tmux.nix
    ./hypr.nix
  ];

  users.users.eugene = {
    isNormalUser = true;
    description = "Eugene";
    extraGroups = [ "networkmanager" "wheel" "incus-admin" "incus" ];
  }; 
}
