{ ... }:

{
  # Enable Docker
  virtualisation.docker.enable = true;

  # Add docker group
  users.users.jeffrey = {
    extraGroups = [ "docker" ];
  };

  # Portainer agent port
  networking.firewall = {
    allowedTCPPorts = [ 9001 ];
    allowedUDPPorts = [ 9001 ];
  };
}
