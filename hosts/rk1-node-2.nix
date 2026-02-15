{ ... }:
{
  imports = [
    ../modules/common.nix
    ../modules/minecraft.nix
  ];

  system.stateVersion = "25.11";
}
