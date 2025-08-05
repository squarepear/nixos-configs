{ config, pkgs, ... }:

{
  # Enable NetworkManager
  networking.networkmanager.enable = true;
  users.users.${config.pear.user.name}.extraGroups = [ "networkmanager" ];

  # Enable TCP BBR
  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl."net.core.default_qdisc" = "fq";
  boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";

  # # Disable dhcpd service
  # networking.dhcpcd.enable = false;

  # Enable avahi for hostname.local
  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.workstation = true;

  programs.mtr.enable = true;

  my.home.packages = with pkgs; lib.mkIf config.pear.desktop.enable [
    networkmanagerapplet
  ];
}
