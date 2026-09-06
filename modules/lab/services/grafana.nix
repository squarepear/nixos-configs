{ config, lib, ... }:

let
  cfg = config.pear.lab.service.grafana;
in
{
  options.pear.lab.service.grafana = {
    enable = lib.mkEnableOption "Grafana dashboards";
  };

  config = lib.mkMerge [
    {
      pear.lab.proxyRoutes.grafana = {
        subdomain = "grafana";
        port = 3090;
      };
    }
    (lib.mkIf cfg.enable {
      age.secrets.lab-grafana-admin-password = {
        file = ../../../secrets/lab/grafana-admin-password.age;
        owner = "grafana";
        group = "grafana";
      };

      age.secrets.lab-grafana-secret-key = {
        file = ../../../secrets/lab/grafana-secret-key.age;
        owner = "grafana";
        group = "grafana";
      };

      services.grafana = {
        enable = true;

        settings = {
          server = {
            http_addr = "0.0.0.0";
            http_port = 3090;
          };

          security = {
            admin_user = "jeffrey";
            admin_password = "$__file{${config.age.secrets.lab-grafana-admin-password.path}}";

            secret_key = "$__file{${config.age.secrets.lab-grafana-secret-key.path}}";
          };

          analytics.reporting_enabled = false;
        };

        provision.datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://localhost:9090";
            isDefault = true;
          }
        ];
      };
    })
  ];
}
