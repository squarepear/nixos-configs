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
      tepig = [
        "home-assistant"
        "ntfy"
      ];
      uxie = [
        "copyparty"
        "dash"
        "immich"
        "jellyfin"
        "open-webui"
        "reverse-proxy"
      ];
    };
  };
}
