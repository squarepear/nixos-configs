{ config, lib, ... }:

let
  cfg = config.pear.lab.service.searxng;
in
{
  options.pear.lab.service.searxng.enable = lib.mkEnableOption "SearXNG meta search engine";

  config = lib.mkMerge [
    {
      pear.lab.proxyRoutes.searxng = {
        subdomain = "search";
        port = 8888;
      };
    }
    (lib.mkIf cfg.enable {
      age.secrets.lab-searxng-env = {
        file = ../../../secrets/lab/searxng-env.age;
        owner = "searx";
        group = "searx";
      };

      services.searx = {
        enable = true;

        environmentFile = config.age.secrets.lab-searxng-env.path;

        settings = {
          general = {
            debug = false;
            instance_name = "Pear Search";
            privacypolicy_url = false;
            donation_url = false;
            contact_url = false;
            enable_metrics = true;
            open_metrics = "";
          };

          server = {
            port = 8888;
            bind_address = "0.0.0.0";
            base_url = "https://search.hl.pear.cx";
            limiter = false;
            public_instance = false;
            secret_key = "$SEARX_SECRET_KEY";
          };

          # Enable useful engines (subset of the full list)
          engines = [
            # General search
            {
              name = "duckduckgo";
              engine = "duckduckgo";
              shortcut = "ddg";
            }

            # Image search
            {
              name = "wikicommons.images";
              engine = "wikicommons";
              shortcut = "wci";
              categories = [ "images" ];
              wc_search_type = "image";
            }

            # Video search
            {
              name = "youtube";
              engine = "youtube_noapi";
              shortcut = "yt";
            }

            # Map search
            {
              name = "openstreetmap";
              engine = "openstreetmap";
              shortcut = "osm";
            }

            # IT / Programming
            {
              name = "github";
              engine = "github";
              shortcut = "gh";
            }
            {
              name = "stackoverflow";
              engine = "stackexchange";
              shortcut = "st";
              api_site = "stackoverflow";
              categories = [
                "it"
                "q&a"
              ];
            }
            {
              name = "arch linux wiki";
              engine = "archlinux";
              shortcut = "al";
            }
            {
              name = "gentoo";
              engine = "mediawiki";
              shortcut = "ge";
              categories = [
                "it"
                "software wikis"
              ];
              base_url = "https://wiki.gentoo.org/";
              api_path = "api.php";
              search_type = "text";
              timeout = 10;
            }
            {
              name = "nixos wiki";
              engine = "mediawiki";
              shortcut = "nixw";
              base_url = "https://wiki.nixos.org/";
              search_type = "text";
              categories = [
                "it"
                "software wikis"
              ];
            }
            {
              name = "docker hub";
              engine = "docker_hub";
              shortcut = "dh";
              categories = [
                "it"
                "packages"
              ];
            }

            # Science & Reference
            {
              name = "arxiv";
              engine = "arxiv";
              shortcut = "arx";
            }
            {
              name = "wikipedia";
              engine = "wikipedia";
              shortcut = "wp";
              display_type = [ "infobox" ];
              categories = [ "general" ];
            }
            {
              name = "wikidata";
              engine = "wikidata";
              shortcut = "wd";
              timeout = 3.0;
              weight = 2;
              display_type = [ "infobox" ];
              categories = [ "general" ];
            }
            {
              name = "wiktionary";
              engine = "mediawiki";
              shortcut = "wt";
              categories = [
                "dictionaries"
                "wikimedia"
              ];
              base_url = "https://{language}.wiktionary.org/";
              search_type = "text";
            }
            {
              name = "pubmed";
              engine = "pubmed";
              shortcut = "pub";
            }
            {
              name = "semantic scholar";
              engine = "semantic_scholar";
              shortcut = "se";
            }
            {
              name = "openalex";
              engine = "openalex";
              shortcut = "oa";
              timeout = 5.0;
            }
            {
              name = "pdbe";
              engine = "pdbe";
              shortcut = "pdb";
            }

            # Utilities
            {
              name = "currency";
              engine = "currency_convert";
              shortcut = "cc";
            }
            {
              name = "wttr.in";
              engine = "wttr";
              shortcut = "wttr";
              timeout = 9.0;
            }
            {
              name = "dictzone";
              engine = "dictzone";
              shortcut = "dc";
            }
            {
              name = "wikicommons.files";
              engine = "wikicommons";
              shortcut = "wcf";
              categories = [ "files" ];
              wc_search_type = "file";
            }
          ];
        };
      };
    })
  ];
}
