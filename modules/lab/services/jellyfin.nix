{
  config,
  lib,
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
    };

    # Shared group so jeffrey can write media files that jellyfin can read.
    users.groups.media = { };
    users.users = lib.mkIf cfg.enable (
      {
        jellyfin.extraGroups = [ "media" ];
      }
      // lib.mapAttrs (_: _: { extraGroups = [ "media" ]; }) config.pear.users.users
    );
  };
}
