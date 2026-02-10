{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../modules/common.nix
  ];

  networking.hostName = "rk1-node-1";

  system.stateVersion = "25.11";
}
