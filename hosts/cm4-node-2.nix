{ ... }:
{
  imports = [
    ../hardware/cm4
    ../modules/common.nix
    ../modules/matrix.nix
    ../modules/mumble.nix
  ];

  system.stateVersion = "23.11";
}
