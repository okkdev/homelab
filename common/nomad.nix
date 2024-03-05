{ config, lib, pkgs, ... }: {
  services.nomad = {
    enable = true;
    package = pkgs.nomad_1_6;
    enableDocker = true;
    dropPrivileges = false;

    settings = {
      datacenter = "home";
      bind_addr = "0.0.0.0";
      client = {
        enabled = true;
        servers = [ "127.0.0.1" ];
      };
      server = {
        enabled = true;
        bootstrap_expect = 2;
        server_join = { retry_join = [ "10.0.0.11" "10.0.0.12" ]; };
      };
    };
  };

  virtualisation = { docker.enable = true; };

  networking.firewall = { allowedTCPPorts = [ 4646 4647 4648 ]; };
}
