{ config, ... }:

{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "100.69.116.34";
        http_port = 2342;
        domain = "grafana.hl.pear.cx";
      };
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;

    exporters = {
      node = {
        enable = true;
        port = 9102;
      };
      nginx = {
        enable = true;
        port = 9003;
      };
    };

    scrapeConfigs = [
      {
        job_name = "tepig";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }

      {
        job_name = "nginx";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.nginx.port}" ];
          }
        ];
      }
    ];
  };
}
