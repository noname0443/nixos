{ config, pkgs, lib, ... }:
{
  users.users.eugene = {
    isNormalUser = true;
    description = "Eugene";
    extraGroups = [ "networkmanager" "wheel" "incus-admin" "incus" ];
  }; 
}
