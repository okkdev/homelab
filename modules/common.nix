{
  config,
  name,
  pkgs,
  ...
}:

{
  # set name from flake host list
  networking.hostName = name;

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

  networking.networkmanager.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "prohibit-password";
  };

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
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

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };

  sops.secrets = {
    desec-acme-token = { };
  };
}
