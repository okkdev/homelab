{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../hardware/cm4/hardware-configuration.nix
    ../modules/common.nix
  ];

  networking.hostName = "cm4-node-2";

  system.stateVersion = "23.11";
}
