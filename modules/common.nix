{
  config,
  name,
  lib,
  hosts,
  pkgs,
  ...
}:

{
  imports = [ ./beszel-agent.nix ];

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
    networkmanager.enable = true;

    # set name from flake host list
    hostName = name;

    # generate /etc/hosts entries for all nodes
    hosts = lib.mkMerge (
      lib.mapAttrsToList (hostname: host: {
        ${host.ipv4} = [ hostname ];
        ${host.ipv6} = [ hostname ];
      }) hosts
    );

    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
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
  sops.secrets = {
    desec-acme-token = { };
  };

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
