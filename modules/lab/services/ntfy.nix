{ config, lib, ... }:

let
  cfg = config.pear.lab.service.ntfy;
in
{
  options.pear.lab.service.ntfy = {
    enable = lib.mkEnableOption "ntfy push notification server";
  };

  config = {
    pear.lab.proxyRoutes.ntfy = {
      subdomain = "ntfy";
      port = 8585;
    };

    services.ntfy-sh = lib.mkIf cfg.enable {
      enable = true;

      settings = {
        base-url = "https://ntfy.hl.pear.cx";
        upstream-base-url = "https://ntfy.sh";
        listen-http = ":8585";
        behind-proxy = true;
      };
    };
  };
}
