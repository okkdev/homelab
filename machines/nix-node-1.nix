{ config, lib, pkgs, ... }@args:

{
  imports = [
    ../hardware/cm4/hardware-configuration.nix
    ../common/common.nix
    ../common/nomad.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    hostName = "nix-node-1";
    networkmanager.enable = true;
  };

  system.stateVersion = "23.11";
}
