{ config, pkgs, ... }:

{
  services.hardware.openrgb = {
    enable = true;

    motherboard = "amd";
  };

  # TODO: Replace with a systemd timer
  services.cron = {
    enable = true;

    systemCronJobs = [
      "0 0 * * *      ${config.user.name}    ${pkgs.openrgb}/bin/openrgb -p off"
      "0 8 * * *      ${config.user.name}    ${pkgs.openrgb}/bin/openrgb -p on"
    ];
  };
}
