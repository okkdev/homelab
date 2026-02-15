{ pkgs-unstable, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    package = pkgs-unstable.papermcServers.papermc-1_21_11;
    dataDir = "/var/lib/minecraft";
    openFirewall = true;
    declarative = true;

    serverProperties = {
      server-port = 25565;
      gamemode = "survival";
      motd = "John Wick more like John Craft";
      max-players = 20;
      difficulty = "normal";
      white-list = true;
      enforce-whitelist = true;

      level-name = "johnmid";
      level-seed = "johnmid";
    };
    whitelist = {
      okischoki = "2361434f-44ac-4061-a7c3-0144b716e758";
      ArcueidNem = "9ac3eb8e-eab1-449d-9454-257cc0d53ce6";
      DarkKyuu = "76b42f29-ecc0-4618-9c0b-26b80860737d";
    };

    jvmOpts = "-Xms4G -Xmx4G";
  };
}
