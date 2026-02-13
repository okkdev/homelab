{ pkgs-unstable, ... }:
{
  services.beszel.hub = {
    enable = true;
    package = pkgs-unstable.beszel;
    port = 8090;
    host = "0.0.0.0";
    environment = {
      APP_URL = "https://beszel.goo.garden";
      AUTO_LOGIN = "dev@stehlik.me";
    };
  };
}
