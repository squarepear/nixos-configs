{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.openrgb ];
  services.udev.packages = [ pkgs.openrgb ];

  boot.kernelModules = [ "i2c-dev" "i2c-piix" ];

  systemd.services.openrgb = {
    description = "OpenRGB server daemon";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.openrgb}/bin/openrgb --server --server-port 6742";
      Restart = "always";
    };
  };
}
