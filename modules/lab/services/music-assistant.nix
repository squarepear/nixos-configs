{
  config,
  lib,
  ...
}:

let
  cfg = config.pear.lab.service.music-assistant;
in
{
  options.pear.lab.service.music-assistant = {
    enable = lib.mkEnableOption "Music Assistant";
  };

  config = lib.mkMerge [
    {
      pear.lab.proxyRoutes.music-assistant = {
        subdomain = "music";
        port = 8095;
      };
    }
    (lib.mkIf cfg.enable {
      networking.firewall = {
        allowedTCPPorts = [
          8095 # Web interface
          8097 # Audio stream served to players
          5000 # AirPlay 1 / RAOP control
          7000 # AirPlay 2 control
        ];
        allowedUDPPorts = [ 5353 ]; # AirPlay device discovery (mDNS)
        # AirPlay picks random high UDP ports for the audio stream itself.
        allowedUDPPortRanges = [
          {
            from = 32768;
            to = 65535;
          }
        ];
      };

      # Podman refuses to start a bind mount whose source directory is missing,
      # so the data directory has to exist before the container is created.
      systemd.tmpfiles.rules = [
        "d /mnt/main-pool/homelab/music-assistant 0750 root root -"
      ];

      # The official image is used instead of the nixpkgs package because it ships
      # the bundled app credentials that providers such as Apple Music need.
      virtualisation.oci-containers = {
        backend = "podman";
        containers.musicassistant = {
          volumes = [
            "/mnt/main-pool/homelab/music-assistant:/data"
            "/mnt/main-pool/media:/media:ro"
          ];
          environment.TZ = "America/Indianapolis";
          image = "ghcr.io/music-assistant/server:2.10.9";
          extraOptions = [
            "--network=host"
          ];
        };
      };
    })
  ];
}
