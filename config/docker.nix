{ config, ... }:

{
  # Enable Docker
  virtualisation.docker.enable = true;

  # Add docker group
  users.users."${config.user.name}" = {
    extraGroups = [ "docker" ];
  };

  # Portainer agent port
  networking.firewall = {
    allowedTCPPorts = [ 9001 ];
    allowedUDPPorts = [ 9001 ];
  };
}
