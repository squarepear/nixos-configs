{ config, ... }:

{
  # Set hostname
  networking.hostName = config.system.name;

  # Enable Connman
  services.connman = {
    enable = true;

    wifi.backend = "iwd";
  };

  # # Disable dhcpd service
  # networking.dhcpcd.enable = false;

  # Enable avahi for hostname.local
  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.workstation = true;

  programs.mtr.enable = true;
}
