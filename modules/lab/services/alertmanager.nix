{
  config,
  lib,
  ...
}:

let
  cfg = config.pear.lab.service.alertmanager;
in
{
  options.pear.lab.service.alertmanager = {
    enable = lib.mkEnableOption "Alertmanager with ntfy delivery";
  };

  config = lib.mkIf cfg.enable {
    age.secrets.lab-alertmanager-ntfy-url.file = ../../../secrets/lab/alertmanager-ntfy-url.age;

    services.prometheus.alertmanager = {
      enable = true;
      port = 9093;
      listenAddress = "0.0.0.0";

      environmentFile = config.age.secrets.lab-alertmanager-ntfy-url.path;

      configText = ''
        route:
          group_by: ['instance', 'severity']
          group_wait: 30s
          group_interval: 5m
          repeat_interval: 4h
          receiver: ntfy

        receivers:
          - name: ntfy
            webhook_configs:
              - url: "http://$NTFY_URL?template=alertmanager"
                send_resolved: true
      '';
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
      9093
    ];
  };
}
