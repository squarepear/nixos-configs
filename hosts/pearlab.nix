{ ... }:

{
  pear.lab = {
    services = {
      reshiram = [ "node-exporter" ];
      tepig = [
        "home-assistant"
        "node-exporter"
        "ntfy"
      ];
      uxie = [
        "alertmanager"
        "copyparty"
        "dash"
        # "forgejo"
        "grafana"
        "immich"
        "jellyfin"
        "music-assistant"
        "node-exporter"
        "prometheus"
        "reverse-proxy"
        "wyoming"
      ];
    };
  };
}
