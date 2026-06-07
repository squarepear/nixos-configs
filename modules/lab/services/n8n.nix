{ config, lib, ... }:

let
  cfg = config.pear.lab.service.n8n;
in
{
  options.pear.lab.service.n8n = {
    enable = lib.mkEnableOption "n8n workflow automation";
  };

  config = {
    pear.lab.proxyRoutes.n8n = {
      subdomain = "n8n";
      port = 5678;
    };

    services.n8n.enable = lib.mkIf cfg.enable true;

    pear.system.impermanence.persist.directories = lib.mkIf cfg.enable [
      "/var/lib/n8n"
    ];
  };
}
