{ config, ... }:
{
  services.caddy = {
    enable = true;
    enableReload = true;
    globalConfig = ''
      grace_period 1m
    '';
    virtualHosts = {
      "(goo_garden_cert)".extraConfig = ''
        tls ${config.security.acme.certs."goo.garden".directory}/fullchain.pem ${
          config.security.acme.certs."goo.garden".directory
        }/key.pem
      '';
      "goo.garden".extraConfig = ''
        import goo_garden_cert

        handle /.well-known/matrix/server {
          header Content-Type application/json
          respond `{"m.server": "matrix.goo.garden:443"}`
        }
        handle /.well-known/matrix/client {
          header Content-Type application/json
          header Access-Control-Allow-Origin "*"
          respond `{"m.homeserver": {"base_url": "https://matrix.goo.garden"}}`
        }

        handle {
          respond "hi :3"
        }
      '';
      "*.goo.garden".extraConfig = ''
        import goo_garden_cert
        abort
      '';
      "matrix.goo.garden".extraConfig = ''
        reverse_proxy cm4-node-2:6167
      '';
      "beszel.goo.garden".extraConfig = ''
        reverse_proxy localhost:${toString config.services.beszel.hub.port}
      '';
      "nas.goo.garden".extraConfig = ''
        reverse_proxy 10.0.0.2:5000
      '';
    };
  };

  security.acme.certs."goo.garden" = {
    extraDomainNames = [ "*.goo.garden" ];
    group = config.services.caddy.group;
    reloadServices = [ "caddy" ];
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
