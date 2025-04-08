{ config, lib, ... }:

with lib;

let
  root = "hl.pear.cx";

  uxie = "100.78.45.59";
  tepig = "100.69.116.34";
in
{
  age.secrets.tepig-cloudflare-creds.file = ../../secrets/tepig/cloudflare-creds.age;

  security.acme = {
    acceptTerms = true;
    defaults.email = "letsencrypt@jeffreyharmon.dev";

    certs."${root}" = {
      domain = "${root}";
      extraDomainNames = [ "*.${root}" ];
      dnsProvider = "cloudflare";
      environmentFile = config.age.secrets.tepig-cloudflare-creds.path;
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = builtins.foldl'
      (acc: site: acc // {
        "${site.name}.${root}" = {
          useACMEHost = "${root}";
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${site.ip}:${builtins.toString site.port}";
            proxyWebsockets = true;
          };
        };
      })
      { }
      [
        {
          name = "ai";
          ip = uxie;
          port = 14141;
        }

        {
          name = "feed";
          ip = tepig;
          port = 8082;
        }

        {
          name = "grafana";
          ip = tepig;
          port = 2342;
        }

        {
          name = "ha";
          ip = tepig;
          port = 8123;
        }

        {
          name = "immich";
          ip = uxie;
          port = 2283;
        }

        {
          name = "jellyfin";
          ip = uxie;
          port = 8096;
        }

        {
          name = "ntfy";
          ip = tepig;
          port = 8585;
        }
      ];
  };
}
