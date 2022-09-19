{ config, ... }:

{
  # Enable Docker
  virtualisation.docker = {
    enable = true;

    liveRestore = false;
  };

  # Add docker group
  users.users."${config.user.name}" = {
    extraGroups = [ "docker" ];
  };
}
