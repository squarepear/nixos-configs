{ config, lib, ... }:

let
  cfg = config.pear.lab.service.rssfeed;
in
{
  options.pear.lab.service.rssfeed = {
    enable = lib.mkEnableOption "RSS feed reader (Miniflux)";
  };

  config = {
    pear.lab.proxyRoutes.rssfeed = {
      subdomain = "feed";
      port = 8082;
    };

    age.secrets.lab-miniflux-admin = lib.mkIf cfg.enable {
      file = ../../../secrets/lab/miniflux-admin.age;
    };

    services.miniflux = lib.mkIf cfg.enable {
      enable = true;

      config.LISTEN_ADDR = "0.0.0.0:8082";
      adminCredentialsFile = config.age.secrets.lab-miniflux-admin.path;
    };
  };
}
