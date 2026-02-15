{
  config,
  name,
  lib,
  hosts,
  host,
  pkgs,
  ...
}:

{
  imports = [
    ./beszel/agent.nix
    ./restic.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjSSxTbR4cq3IqMX3VKkB4inGeBmmE9UtO0IHwxg92O dev@stehlik.me"
    ];
  };

  environment.systemPackages = with pkgs; [
    nfs-utils
    vim
    btop
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "prohibit-password";
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;

    # set name from flake host list
    hostName = name;

    # generate /etc/hosts entries for all nodes
    hosts = lib.mkMerge (
      lib.mapAttrsToList (hostname: h: {
        ${h.ipv4} = [ hostname ];
        ${h.ipv6} = [ hostname ];
      }) hosts
    );

    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  systemd.network = {
    enable = true;
    networks."10-lan" = {
      matchConfig.Name = "end0";
      address = [
        "${host.ipv4}/24"
        "${host.ipv6}/64"
      ];
      gateway = [ "10.0.0.1" ];
      networkConfig = {
        IPv6AcceptRA = true;
      };
      ipv6AcceptRAConfig = {
        UseDNS = true;
      };
    };
  };

  # mount synology nas nfs
  boot.supportedFilesystems = [ "nfs" ];
  fileSystems."/mnt/nas" = {
    device = "10.0.0.2:/volume1/nfs";
    fsType = "nfs";
    options = [
      "nfsvers=4.1"
      "rw"
      "nofail"
      "_netdev"
      "soft"
      "timeo=150"
    ];
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      server = "https://acme-v02.api.letsencrypt.org/directory";
      email = "dev@stehlik.me";
      dnsProvider = "desec";
      extraLegoFlags = [ "--dns.propagation-wait=300s" ];
      credentialFiles = {
        # dont forget to add needed subdomains to token policy
        DESEC_TOKEN_FILE = config.sops.secrets.desec-acme-token.path;
      };
    };
  };
  sops.secrets.desec-acme-token = { };

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
