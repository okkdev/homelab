{ config, lib, pkgs, ... }:

{
  imports = [
    ../hardware/cm4/hardware-configuration.nix
    ../common/common.nix
    ../common/nomad.nix
  ];

  networking.hostName = "nix-node-2";

  system.stateVersion = "23.11";
}
