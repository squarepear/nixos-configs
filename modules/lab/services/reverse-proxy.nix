{ config, lib, ... }:

let
  cfg = config.pear.lab.service.reverse-proxy;
  labCfg = config.pear.lab;
  root = "hl.pear.cx";

  # For a given service name, find which host runs it.
  hostForService =
    svcName:
    lib.findFirst (
      hostName: lib.elem svcName (labCfg.services.${hostName} or [ ])
    ) (throw "pear.lab: no host defined for service '${svcName}'") (lib.attrNames labCfg.services);

  # Build vhosts from all declared proxy routes.
  vhosts = lib.mapAttrs' (
    svcName: route:
    lib.nameValuePair "${route.subdomain}.${root}" {
      useACMEHost = root;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${labCfg.hosts.${hostForService svcName}}:${toString route.port}";
        proxyWebsockets = true;
      };
    }
  ) labCfg.proxyRoutes;
in
{
  options.pear.lab.service.reverse-proxy = {
    enable = lib.mkEnableOption "reverse proxy (nginx + ACME)";
  };

  config = lib.mkIf cfg.enable {
    age.secrets.lab-cloudflare-creds.file = ../../../secrets/lab/cloudflare-creds.age;

    security.acme = {
      acceptTerms = true;
      defaults.email = "letsencrypt@jeffreyharmon.dev";
      defaults.extraLegoFlags = [
        "--dns.propagation-wait"
        "300s"
      ];

      certs."${root}" = {
        domain = "${root}";
        extraDomainNames = [ "*.${root}" ];
        dnsProvider = "cloudflare";
        environmentFile = config.age.secrets.lab-cloudflare-creds.path;
      };
    };

    users.users.nginx.extraGroups = [ "acme" ];

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = vhosts;
    };
  };
}
