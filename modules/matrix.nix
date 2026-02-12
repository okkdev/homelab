{ ... }:
{
  services.matrix-continuwuity = {
    enable = true;
    settings = {
      global = {
        server_name = "goo.garden";
        address = [
          "0.0.0.0"
          "::"
        ];
        port = [ 6167 ];
        allow_registration = false;
        allow_encryption = true;
        allow_federation = true;
        trusted_servers = [
          "matrix.org"
          "events.ccc.de"
          "kabelsalat.ch"
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 6167 ];
}
