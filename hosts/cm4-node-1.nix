{ ... }:
{
  imports = [
    ../hardware/cm4
    ../modules/common.nix
    ../modules/tailscale.nix
    ../modules/caddy.nix
    ../modules/dyndns.nix
    ../modules/beszel/hub.nix
  ];

  system.stateVersion = "23.11";
}
