{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.restic ];

  services.restic.backups = {
    homeserver = {
      initialize = true;

      repository = "sftp:user@synology-ip:/volume1/backups/homeserver";

      passwordFile = "/etc/restic/password";

      paths = [
        "/home"
        "/var/lib"
      ];

      exclude = [
        "/var/lib/docker"
        "*.tmp"
        ".cache"
      ];

      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];
    };
  };
}
