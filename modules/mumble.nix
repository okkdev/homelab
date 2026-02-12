{ config, ... }:
{
  services.murmur = {
    enable = true;
    openFirewall = true;
    hostName = ""; # binds all
    port = 64738;
    environmentFile = config.sops.secrets."mumble.env".path;

    registerHostname = "mumble.goo.garden";
    registerName = "📞 mumble.goo.garden";
    welcometext = "more like John Goo";

    password = "$MUMBLE_PASSWORD";
    users = 50;

    sslCert = "${config.security.acme.certs."mumble.goo.garden".directory}/fullchain.pem";
    sslKey = "${config.security.acme.certs."mumble.goo.garden".directory}/key.pem";
  };

  security.acme.certs."mumble.goo.garden" = {
    group = config.services.murmur.group;
  };

  sops.secrets."mumble.env" = {
    sopsFile = ../secrets/mumble.env;
    format = "dotenv";
  };
}
