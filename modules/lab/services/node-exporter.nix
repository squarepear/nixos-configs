{
  config,
  lib,
  ...
}:

let
  cfg = config.pear.lab.service.node-exporter;
in
{
  options.pear.lab.service.node-exporter = {
    enable = lib.mkEnableOption "node exporter for host metrics";
  };

  config = lib.mkIf cfg.enable {
    services.prometheus.exporters.node = {
      enable = true;
      port = 9100;
      openFirewall = false;
      enabledCollectors = [
        "systemd"
        "hwmon"
        "processes"
        "swap"
      ];
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
      9100
    ];
  };
}
