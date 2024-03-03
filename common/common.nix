{ config, lib, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjSSxTbR4cq3IqMX3VKkB4inGeBmmE9UtO0IHwxg92O dev@stehlik.me"
    ];
  };

  environment.systemPackages = with pkgs; [ vim ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "prohibit-password";
  };
}
