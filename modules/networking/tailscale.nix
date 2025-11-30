{ config, lib, ... }:

let
  cfg = config.pear.networking.tailscale;
  impermanenceCfg = config.pear.services.impermanence;
in
{
  options.pear.networking.tailscale = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.pear.networking.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;

      useRoutingFeatures = "both";
      openFirewall = true;
    };

    environment.persistence."/persist".directories = lib.mkIf impermanenceCfg.enable [
      "/var/lib/tailscale"
    ];
  };
}
