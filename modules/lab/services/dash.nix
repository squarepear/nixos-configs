{ config, lib, ... }:

let
  cfg = config.pear.lab.service.dash;

  feeds = {
    "NixOS" = "https://nixos.org/blog/feed.xml";
    "GamingOnLinux" = "https://www.gamingonlinux.com/article_rss.php";
  };
in
{
  options.pear.lab.service.dash = {
    enable = lib.mkEnableOption "Glance dashboard service.";
  };

  config = lib.mkMerge [
    {
      pear.lab.proxyRoutes.dash = {
        subdomain = "dash";
        port = 4309;
      };
    }
    (lib.mkIf cfg.enable {
      age.secrets.lab-glance-env.file = ../../../secrets/lab/glance-env.age;

      services.glance = lib.mkIf cfg.enable {
        enable = true;

        environmentFile = config.age.secrets.lab-glance-env.path;
        settings = {
          server = {
            host = "0.0.0.0";
            port = config.pear.lab.proxyRoutes.dash.port;
            proxied = true;
          };

          pages = [
            {
              name = "Startpage";
              width = "wide";
              center-vertically = true;

              columns = [
                {
                  size = "small";
                  widgets = [
                    {
                      type = "clock";
                      hour-format = "12h";
                    }
                    {
                      type = "weather";
                      units = "imperial";
                      location = "\${LOCATION}";
                      hide-location = true;
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    {
                      type = "search";
                      autofocus = true;
                      bangs = [
                        {
                          title = "GitHub";
                          shortcut = "!gh";
                          url = "https://github.com/search?q={QUERY}";
                        }
                        {
                          title = "YouTube";
                          shortcut = "!yt";
                          url = "https://www.youtube.com/results?search_query={QUERY}";
                        }
                        {
                          title = "Wiki";
                          shortcut = "!w";
                          url = "https://en.wikipedia.org/w/index.php?search={QUERY}";
                        }
                        {
                          title = "Open WebUI";
                          shortcut = "!ai";
                          url = "https://ai.hl.pear.cx/?q={QUERY}";
                        }
                        {
                          title = "NixOS";
                          shortcut = "!nix";
                          url = "https://search.nixos.org/packages?query={QUERY}";
                        }
                      ];
                    }
                    {
                      type = "monitor";
                      cache = "1m";
                      title = "Services";
                      sites = [
                        {
                          title = "Jellyfin";
                          url = "https://jellyfin.hl.pear.cx/";
                          icon = "si:jellyfin";
                          same-tab = true;
                          timeout = "5s";
                        }
                        {
                          title = "Immich";
                          url = "https://immich.hl.pear.cx/";
                          icon = "si:immich";
                          same-tab = true;
                          timeout = "5s";
                        }
                        {
                          title = "Open WebUI";
                          url = "https://ai.hl.pear.cx/";
                          icon = "sh:open-webui-light";
                          same-tab = true;
                          timeout = "5s";
                        }
                        {
                          title = "Home Assistant";
                          url = "https://ha.hl.pear.cx/";
                          icon = "si:homeassistant";
                          same-tab = true;
                          timeout = "5s";
                        }
                        {
                          title = "ntfy";
                          url = "https://ntfy.hl.pear.cx/";
                          icon = "si:ntfy";
                          same-tab = true;
                          timeout = "5s";
                        }
                        {
                          title = "Copyparty";
                          url = "https://nas.hl.pear.cx/";
                          icon = "sh:copyparty-light";
                          same-tab = true;
                          timeout = "5s";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
            {
              name = "News";
              width = "wide";
              columns = [
                {
                  size = "small";
                  widgets = [
                    {
                      type = "lobsters";
                      limit = 15;
                      collapse-after = 8;
                      sort-by = "hot";
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    {
                      type = "rss";
                      title = "News Feeds";
                      cache = "30m";
                      style = "vertical-list";
                      collapse-after = 8;
                      feeds = lib.mapAttrsToList (name: url: {
                        title = name;
                        url = url;
                      }) feeds;
                    }
                  ];
                }
              ];
            }
          ];
        };
      };
    })
  ];
}
