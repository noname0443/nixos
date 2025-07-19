{ config, pkgs, lib, ... }:
{
  programs.fish.enable = true;
  users.users.eugene = {
    isNormalUser = true;
    description = "Eugene";
    extraGroups = [ "networkmanager" "wheel" "incus-admin" "incus" ];
    shell = pkgs.fish;
  };
}
