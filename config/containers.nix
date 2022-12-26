{ config, pkgs, ... }:

{
  # Enable Podman
  virtualisation.podman = {
    enable = true;

    dockerCompat = true;
  };

  # Add extra packages
  environment.systemPackages = with pkgs; [
    distrobox
    podman-compose
  ];

  # Add podman group
  users.users."${config.user.name}" = {
    extraGroups = [ "podman" ];
  };
}
