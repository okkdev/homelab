{ config, name, ... }:
{
  services.beszel.agent = {
    enable = true;
    openFirewall = true;
    environmentFile = config.sops.secrets."beszel-agent.env".path;
  };

  sops.secrets."beszel-agent.env" = {
    sopsFile = ../secrets/beszel-agent-${name}.env;
    format = "dotenv";
  };
}
