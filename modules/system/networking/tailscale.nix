{ config, lib, ... }:

let
  cfg = config.pear.system.networking.tailscale;
in
{
  options.pear.system.networking.tailscale = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.pear.system.networking.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;

      useRoutingFeatures = "both";
      openFirewall = true;
    };

    pear.system.impermanence.persist.directories = [
      "/var/lib/tailscale"
    ];
  };
}
