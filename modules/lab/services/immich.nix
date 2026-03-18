{ config, lib, ... }:

let
  cfg = config.pear.lab.service.immich;
in
{
  options.pear.lab.service.immich = {
    enable = lib.mkEnableOption "Immich photo management";
  };

  config = {
    pear.lab.proxyRoutes.immich = {
      subdomain = "immich";
      port = 2283;
    };

    services.immich = lib.mkIf cfg.enable {
      enable = true;

      host = "0.0.0.0";
      openFirewall = true;
      mediaLocation = "/mnt/main-pool/homelab/immich/media";
      machine-learning.enable = false;
    };
  };
}
