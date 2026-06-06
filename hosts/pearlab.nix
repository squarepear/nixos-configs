{ ... }:

let
  hosts = import ./info.nix;
in

{
  pear.lab = {
    hosts = {
      tepig = hosts.tepig.ip;
      uxie = hosts.uxie.ip;
    };

    services = {
      tepig = [ "home-assistant" "ntfy" "rssfeed" ];
      uxie = [ "copyparty" "immich" "jellyfin" "n8n" "open-webui" "reverse-proxy" "searxng" ];
    };
  };
}
