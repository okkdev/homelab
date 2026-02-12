{ ... }:
{
  services.beszel.hub = {
    enable = true;
    port = 8090;
    host = "0.0.0.0";
    environment = {
      APP_URL = "https://beszel.goo.garden";
      AUTO_LOGIN = "dev@stehlik.me";
    };
  };
}
