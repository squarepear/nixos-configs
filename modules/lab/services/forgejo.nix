{
  config,
  lib,
  ...
}:

let
  cfg = config.pear.lab.service.forgejo;
in
{
  options.pear.lab.service.forgejo = {
    enable = lib.mkEnableOption "Forgejo service";
  };

  config = {
    pear.lab.proxyRoutes.forgejo = {
      subdomain = "git";
      port = 3085;
    };

    services.forgejo = lib.mkIf cfg.enable {
      enable = true;

      database.type = "postgres";
      lfs.enable = true;

      stateDir = "/mnt/main-pool/homelab/forgejo";

      settings = {
        server = {
          DOMAIN = "git.hl.pear.cx";
          ROOT_URL = "https://git.hl.pear.cx";
          HTTP_ADDR = "0.0.0.0";
          HTTP_PORT = 3085;
          DISABLE_SSH = true;
        };

        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
      };
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = lib.mkIf cfg.enable [
      3085
    ];
  };
}
