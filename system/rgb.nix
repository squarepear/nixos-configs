{ config, lib, pkgs, ... }:

{
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb_git;

    motherboard = "amd";
  };

  # TODO: Replace with a systemd timer
  services.cron = {
    enable = true;

    systemCronJobs = [
      "0 21 * * *      ${config.pear.user.name}    ${lib.getExe pkgs.openrgb} -p off"
      "0 8 * * *      ${config.pear.user.name}    ${lib.getExe pkgs.openrgb} -p on"
    ];
  };

  # my.systemd.user.services.openrgb-on = {
  #   Unit = { Description = "Turn on rgb lights"; };

  #   Service = {
  #     ExecStart = "${pkgs.openrgb}/bin/openrgb -p on";
  #   };
  # };

  # my.systemd.user.timers.openrgb-on = {
  #   Unit.Description = "Turn on rgb lights";

  #   Timer = {
  #     Unit = "openrgb-on.service";
  #     OnCalendar = "08:00:00";
  #     Persistent = true;
  #   };

  #   Install.WantedBy = [ "timers.target" ];
  # };

  # my.systemd.user.services.openrgb-off = {
  #   Unit = { Description = "Turn off rgb lights"; };

  #   Service = {
  #     ExecStart = "${pkgs.openrgb}/bin/openrgb -p off";
  #   };
  # };

  # my.systemd.user.timers.openrgb-off = {
  #   Unit.Description = "Turn off rgb lights";

  #   Timer = {
  #     Unit = "openrgb-off.service";
  #     OnCalendar = "21:00:00";
  #     Persistent = true;
  #   };

  #   Install.WantedBy = [ "timers.target" ];
  # };
}
