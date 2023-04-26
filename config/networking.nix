{ config, pkgs, ... }:

{
  # Enable Connman
  services.connman = {
    enable = true;
    package = pkgs.connmanFull;

    wifi.backend = "iwd";
  };

  networking.wireless.iwd.enable = true;

  # # Disable dhcpd service
  # networking.dhcpcd.enable = false;

  # Enable avahi for hostname.local
  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.workstation = true;

  programs.mtr.enable = true;

  my.home.packages = with pkgs; lib.mkIf config.system.gui.enable [
    cmst
  ];
}
