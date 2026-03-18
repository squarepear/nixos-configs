{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.system.lab;
  labCfg = config.pear.lab;
  hostname = config.networking.hostName;
in
{
  imports = [
    ../../hosts/pearlab.nix
    ./services/copyparty.nix
    ./services/home-assistant.nix
    ./services/immich.nix
    ./services/jellyfin.nix
    ./services/n8n.nix
    ./services/ntfy.nix
    ./services/open-webui.nix
    ./services/reverse-proxy.nix
    ./services/rssfeed.nix
  ];

  options.pear.system.lab = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "pearlab";
      description = "Whether to enable the homelab environment.";
    };
  };

  options.pear.lab = {
    hosts = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Map of lab host names to their IP addresses.";
    };

    services = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = { };
      description = "Map of host names to the list of services they run.";
    };

    proxyRoutes = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            subdomain = lib.mkOption {
              type = lib.types.str;
              description = "Subdomain under the lab root domain.";
            };
            port = lib.mkOption {
              type = lib.types.port;
              description = "Port the service listens on.";
            };
          };
        }
      );
      default = { };
      description = "Map of service name to proxy metadata, auto-collected from enabled services.";
    };
  };

  config = lib.mkIf cfg.enable {
    pear.lab.service = lib.genAttrs (labCfg.services.${hostname} or [ ]) (_: {
      enable = true;
    });
  };
}
