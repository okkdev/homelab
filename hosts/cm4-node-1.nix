{ ... }:
{
  imports = [
    ../hardware/cm4
    ../modules/common.nix
    ../modules/tailscale.nix
    ../modules/caddy.nix
    ../modules/ddclient.nix
  ];

  system.stateVersion = "23.11";
}
