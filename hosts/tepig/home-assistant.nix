{ pkgs, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [
      8123 # Home Assistant web interface
      21063 # HomeKit Bridge
    ];
    allowedUDPPorts = [
      5353 # HomeKit Bridge
    ];
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" ];
      environment.TZ = "America/Indianapolis";
      image = "ghcr.io/home-assistant/home-assistant:2024.7"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [
        "--network=host"
        # "--device=/dev/ttyACM0:/dev/ttyACM0" # Example, change this to match your own hardware
      ];
    };
  };
}
