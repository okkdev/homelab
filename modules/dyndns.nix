{
  config,
  pkgs,
  lib,
  ...
}:
let
  domain = "goo.garden";
  dyndnsDomains = [
    domain
    "mumble.${domain}"
  ];
in
{
  systemd.services.dyndns-update = {
    description = "Update deSEC DynDNS";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      DynamicUser = true;
      StateDirectory = "dyndns-update";
      LoadCredential = "token:${config.sops.secrets.desec-dyndns-token.path}";
    };
    script = ''
      CACHE_FILE="$STATE_DIRECTORY/last-ip"
      TOKEN=$(cat "$CREDENTIALS_DIRECTORY/token")

      CURRENT_IP=$(${pkgs.curl}/bin/curl -4 -sf https://checkipv4.dedyn.io/)

      if [ -z "$CURRENT_IP" ]; then
        echo "Failed to get current IP"
        exit 1
      fi

      LAST_IP=""
      if [ -f "$CACHE_FILE" ]; then
        LAST_IP=$(cat "$CACHE_FILE")
      fi

      if [ "$CURRENT_IP" = "$LAST_IP" ]; then
        echo "IP unchanged ($CURRENT_IP), skipping update"
        exit 0
      fi

      echo "IP changed: $LAST_IP -> $CURRENT_IP, updating..."
      ${pkgs.curl}/bin/curl -4 -sf --ssl-reqd \
        "https://update.dedyn.io/update?hostname=${lib.concatStringsSep "," dyndnsDomains}&myipv4=$CURRENT_IP&myipv6=preserve" \
        -H "Authorization: Token $TOKEN"

      echo "$CURRENT_IP" > "$CACHE_FILE"
    '';
  };

  systemd.timers.dyndns-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "10min";
    };
  };

  sops.secrets.desec-dyndns-token = { };
}
