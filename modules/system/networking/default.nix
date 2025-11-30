{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.system.networking;
in
{
  imports = [
    ./tailscale.nix
  ];

  options.pear.system.networking = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "minimal";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable NetworkManager
    networking.networkmanager.enable = true;

    # Enable BBR TCP congestion control
    boot.kernelModules = [ "tcp_bbr" ];
    boot.kernel.sysctl."net.core.default_qdisc" = "fq";
    boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";

    # Enable mDNS via Avahi
    services.avahi.enable = true;
    services.avahi.publish.enable = true;
    services.avahi.publish.addresses = true;
    services.avahi.publish.workstation = true;

    # Enable MTR program
    programs.mtr.enable = true;

    pear.users.adminGroups = [ "networkmanager" ];
  };
}
