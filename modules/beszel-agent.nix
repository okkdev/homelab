{ config, name, ... }:
{
  services.beszel.agent = {
    enable = true;
    openFirewall = true;
    environmentFile = config.sops.templates."beszel-agent.env".path;
  };

  sops.secrets."beszel-token-${name}" = { };
  sops.templates."beszel-agent.env" = {
    content = ''
      KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXHE/75uA6Qk08PDCcxBiXcbvmx4RNEpMtqNiO3LkN3"
      TOKEN="${config.sops.placeholder."beszel-token-${name}"}"
      HUB_URL="10.0.0.11"
      SKIP_SYSTEMD=false
    '';
  };
}
