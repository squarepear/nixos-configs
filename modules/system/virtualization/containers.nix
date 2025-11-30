{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.system.virtualization.containers;
in
{
  options.pear.system.virtualization.containers = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.anyProfileEnabled [
        "server"
        "development"
      ];
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
