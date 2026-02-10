{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../hardware/cm4
    ../modules/common.nix
  ];

  networking.hostName = "cm4-node-1";

  system.stateVersion = "23.11";
}
