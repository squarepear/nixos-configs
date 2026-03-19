{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pear.lab.service.home-assistant;
in
{
  options.pear.lab.service.home-assistant = {
    enable = lib.mkEnableOption "Home Assistant";
  };

  config = lib.mkMerge [
    {
      pear.lab.proxyRoutes.home-assistant = {
        subdomain = "ha";
        port = 8123;
      };
    }
    (lib.mkIf cfg.enable {
      networking.firewall = {
        allowedTCPPorts = [
          8123 # Home Assistant web interface
          21063 # HomeKit Bridge
        ];
        allowedUDPPorts = [
          5353 # HomeKit Bridge
        ];
      };

      virtualisation.oci-containers = {
        backend = "podman";
        containers.homeassistant = {
          volumes = [ "home-assistant:/config" ];
          environment.TZ = "America/Indianapolis";
          image = "ghcr.io/home-assistant/home-assistant:2026.3";
          extraOptions = [
            "--network=host"
          ];
        };
      };

      services.matter-server.enable = true;
    })
  ];
}
