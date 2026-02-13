{
  config,
  name,
  inputs,
  pkgs-unstable,
  ...
}:
{
  # Use beszel-agent module from PR #461327 (systemd monitoring support)
  disabledModules = [ "services/monitoring/beszel-agent.nix" ];
  imports = [ "${inputs.nixpkgs-beszel-pr}/nixos/modules/services/monitoring/beszel-agent.nix" ];

  services.beszel.agent = {
    enable = true;
    openFirewall = true;
    package = pkgs-unstable.beszel;
    environmentFile = config.sops.templates."beszel-agent.env".path;
  };

  sops.secrets."beszel-token-${name}" = { };
  sops.templates."beszel-agent.env" = {
    content = ''
      KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXHE/75uA6Qk08PDCcxBiXcbvmx4RNEpMtqNiO3LkN3"
      TOKEN="${config.sops.placeholder."beszel-token-${name}"}"
      HUB_URL="10.0.0.11"
      SKIP_GPU=true
    '';
  };
}
