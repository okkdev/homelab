{
  config,
  hosts,
  ...
}:
{
  services.caddy = {
    enable = true;
    enableReload = true;
    globalConfig = ''
      grace_period 1m
    '';
    virtualHosts = {
      "(acme_tls)".extraConfig = ''
        tls ${config.security.acme.certs."goo.garden".directory}/fullchain.pem ${
          config.security.acme.certs."goo.garden".directory
        }/key.pem
      '';
      "goo.garden".extraConfig = ''
        import acme_tls

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
        import acme_tls
        abort
      '';
      "matrix.goo.garden".extraConfig = ''
        reverse_proxy ${hosts.cm4-node-2.ip}:6167
      '';
      "mumble.goo.garden:64738".extraConfig = ''
        reverse_proxy ${hosts.cm4-node-2.ip}:64738
      '';
    };
  };

  security.acme.certs."goo.garden" = {
    extraDomainNames = [ "*.goo.garden" ];
    group = config.services.caddy.group;
    reloadServices = [ "caddy" ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443

      # mumble
      64738
    ];
    allowedUDPPorts = [
      # mumble
      64738
    ];
  };
}
