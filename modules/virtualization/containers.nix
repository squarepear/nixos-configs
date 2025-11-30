{ config, lib, ... }:

let
  cfg = config.pear.virtualization.containers;
in
{
  options.pear.virtualization.containers = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable Podman
    virtualisation.podman = {
      enable = true;

      defaultNetwork.settings.dns_enabled = true;
    };

    # Enable cgroups
    boot.kernelParams = [
      "cgroup_memory=1"
      "cgroup_enable=memory"
    ];

    pear.users.adminGroups = [ "podman" ];
  };
}
