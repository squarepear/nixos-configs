{ config, ... }:

{
  # Enable Docker
  virtualisation.docker.enable = true;

  # Add docker group
  users.users."${config.user.name}" = {
    extraGroups = [ "docker" ];
  };
}
