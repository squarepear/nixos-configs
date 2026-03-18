{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.lab.service.jellyfin;
in
{
  options.pear.lab.service.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin media server";
  };

  config = {
    pear.lab.proxyRoutes.jellyfin = {
      subdomain = "jellyfin";
      port = 8096;
    };

    services.jellyfin = lib.mkIf cfg.enable {
      enable = true;

      openFirewall = true;
      user = builtins.head pearlib.admins;
    };
  };
}
