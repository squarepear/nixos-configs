{ config, ... }:

{
  # Enable Connman
  services.connman = {
    enable = true;

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
}
