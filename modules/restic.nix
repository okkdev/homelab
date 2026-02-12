{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.restic ];

  services.restic.backups = {
    homeserver = {
      initialize = true;

      repositoryFile = config.sops.secrets.backup-repository.path;
      passwordFile = config.sops.secrets.restic-password.path;

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

  programs.ssh = {
    extraConfig = ''
      Host u544487.your-storagebox.de
        IdentityFile ${config.sops.secrets.backup-identity.path}
        IdentitiesOnly yes
    '';
    knownHosts = {
      storage-box = {
        hostNames = [ "u544487.your-storagebox.de" ];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA5EB5p/5Hp3hGW1oHok+PIOH9Pbn7cnUiGmUEBrCVjnAw+HrKyN8bYVV0dIGllswYXwkG/+bgiBlE6IVIBAq+JwVWu1Sss3KarHY3OvFJUXZoZyRRg/Gc/+LRCE7lyKpwWQ70dbelGRyyJFH36eNv6ySXoUYtGkwlU5IVaHPApOxe4LHPZa/qhSRbPo2hwoh0orCtgejRebNtW5nlx00DNFgsvn8Svz2cIYLxsPVzKgUxs8Zxsxgn+Q/UvR7uq4AbAhyBMLxv7DjJ1pc7PJocuTno2Rw9uMZi1gkjbnmiOh6TTXIEWbnroyIhwc8555uto9melEUmWNQ+C+PwAK+MPw==";
      };
    };
  };

  sops.secrets = {
    restic-password = { };
    backup-repository = { };
    backup-identity = { };
  };
}
