{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openrgb
    i2c-tools
  ];

  hardware.i2c.enable = true;

  services.udev.packages = with pkgs; [
    openrgb
  ];

  systemd.services.openrgb = {
    description = "OpenRGB server";

    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.openrgb}/bin/openrgb --server --server-port 6742";
      Restart = "always";
    };
  };
}
