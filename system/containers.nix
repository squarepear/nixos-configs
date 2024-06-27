{ config, pkgs, ... }:

{
  # Enable Podman
  virtualisation.podman = {
    enable = true;

    defaultNetwork.settings.dns_enabled = true;
  };

  # Add extra packages
  environment.systemPackages = with pkgs; [
    distrobox # FIXME: CAUSES FREEZES?
    podman-compose
    fuse-overlayfs
  ];

  # Add podman group
  users.users."${config.pear.user.name}" = {
    extraGroups = [ "podman" ];
  };

  # Enable cgroups
  boot.kernelParams = [ "cgroup_memory=1" "cgroup_enable=memory" ];
}
