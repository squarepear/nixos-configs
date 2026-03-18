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

    nixpkgs.config.allowUnfree = lib.mkIf cfg.enable true;
    services.n8n.enable = lib.mkIf cfg.enable true;
  };
}
