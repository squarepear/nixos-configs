{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pear.lab.service.prometheus;
  hosts = import ../../../hosts/info.nix;

  nodeTargets = lib.mapAttrsToList (name: host: {
    targets = [ "${host.ip}:9100" ];
    labels.instance = name;
  }) hosts;
in
{
  options.pear.lab.service.prometheus = {
    enable = lib.mkEnableOption "Prometheus metrics server";
  };

  config = lib.mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      port = 9090;
      retentionTime = "30d";

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = nodeTargets;
        }
        {
          job_name = "home-assistant";
          metrics_path = "/api/prometheus";
          static_configs = [
            {
              targets = [ "${hosts.tepig.ip}:8123" ];
              labels.instance = "home-assistant";
            }
          ];
        }
      ];
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
      9090
    ];
  };
}
