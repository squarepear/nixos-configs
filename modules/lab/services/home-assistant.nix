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

      systemd.services.home-assistant-dbus-proxy = {
        description = "Filtered D-Bus proxy for Home Assistant (BlueZ only)";
        wantedBy = [ "multi-user.target" ];
        after = [
          "dbus.socket"
          "bluetooth.service"
        ];
        serviceConfig = {
          ExecStart = "${pkgs.xdg-dbus-proxy}/bin/xdg-dbus-proxy unix:path=/run/dbus/system_bus_socket /run/ha-dbus/system_bus_socket --filter --talk=org.bluez";
          RuntimeDirectory = "ha-dbus";
          RuntimeDirectoryMode = "0755";
          Restart = "always";
        };
      };

      systemd.services.podman-homeassistant = {
        after = [ "home-assistant-dbus-proxy.service" ];
        wants = [ "home-assistant-dbus-proxy.service" ];
        requires = [ "home-assistant-dbus-proxy.service" ];
      };

      virtualisation.oci-containers = {
        backend = "podman";
        containers.homeassistant = {
          volumes = [ "home-assistant:/config" ];
          environment = {
            TZ = "America/Indianapolis";
            DBUS_SYSTEM_BUS_ADDRESS = "unix:path=/run/dbus/system_bus_socket";
          };
          image = "ghcr.io/home-assistant/home-assistant:2026.11.0";
          extraOptions = [
            "--network=host"
            "--cap-add=NET_ADMIN"
            "--cap-add=NET_RAW"
            "--volume=/run/ha-dbus:/run/dbus:ro"
          ];
        };
      };

      services.matterjs-server.enable = true;
    })
  ];
}
