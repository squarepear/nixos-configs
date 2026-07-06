{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.lab.service.reverse-proxy;
  labCfg = config.pear.lab;
  impermanence = config.pear.system.impermanence;
  root = "hl.pear.cx";

  # Build Traefik routers from all declared proxy routes.
  routers = lib.mapAttrs' (
    svcName: route:
    lib.nameValuePair svcName {
      rule = "Host(`${route.subdomain}.${root}`)";
      service = svcName;
      tls.certResolver = "letsencrypt";
    }
  ) labCfg.proxyRoutes;

  # Build Traefik services from all declared proxy routes.
  services = lib.mapAttrs' (
    svcName: route:
    lib.nameValuePair svcName {
      loadBalancer.servers = [
        { url = "http://${pearlib.ipForService svcName}:${toString route.port}"; }
      ];
    }
  ) labCfg.proxyRoutes;
in
{
  options.pear.lab.service.reverse-proxy = {
    enable = lib.mkEnableOption "reverse proxy (Traefik + ACME)";
  };

  config = lib.mkIf cfg.enable {
    age.secrets.lab-cloudflare-creds = {
      file = ../../../secrets/lab/cloudflare-creds.age;
      owner = "traefik";
      group = config.services.traefik.group;
    };

    # Inject Cloudflare credentials for the DNS challenge.
    services.traefik.environmentFiles = [
      config.age.secrets.lab-cloudflare-creds.path
    ];

    networking.firewall = {
      allowedTCPPorts = [
        80 # HTTP (redirects to HTTPS)
        443 # HTTPS
      ];
    };

    services.traefik = {
      enable = true;

      dataDir = lib.mkIf impermanence.enable "/persist/var/lib/traefik";

      staticConfigOptions = {
        entryPoints = {
          web = {
            address = ":80";
            http.redirections.entrypoint = {
              to = "websecure";
              scheme = "https";
            };
          };
          websecure = {
            address = ":443";
            http.tls = {
              certResolver = "letsencrypt";
              domains = [
                {
                  main = root;
                  sans = [ "*.${root}" ];
                }
              ];
            };
          };
        };

        api = {
          dashboard = true;
          insecure = true; # binds to localhost:8080 only, access via SSH tunnel
        };

        certificatesResolvers.letsencrypt.acme = {
          email = "letsencrypt@jeffreyharmon.dev";
          storage = "${config.services.traefik.dataDir}/acme.json";
          dnsChallenge = {
            provider = "cloudflare";
            delayBeforeCheck = 30;
            disablePropagationCheck = true;
          };
        };
      };

      dynamicConfigOptions = {
        http = {
          inherit routers services;
        };
      };
    };
  };
}
