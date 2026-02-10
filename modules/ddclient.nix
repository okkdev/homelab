{
  config,
  ...
}:
let
  tld = "goo.garden";
in
{
  services.ddclient = {
    enable = true;
    ssl = true;
    interval = "10min";
    protocol = "dyndns2";
    server = "update.dedyn.io";

    usev4 = "webv4, webv4=https://checkipv4.dedyn.io/";
    usev6 = "webv6, webv6=https://checkipv6.dedyn.io/";

    username = tld;
    passwordFile = config.sops.secrets.desec-dyndns-token.path;
    domains = [ tld ];
  };

  sops.secrets.desec-dyndns-token = { };
}
