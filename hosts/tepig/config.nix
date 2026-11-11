{ pkgs, ... }:
{
  hardware.raspberry-pi."4".bluetooth.enable = true;

  systemd.services.bluetooth-rfkill-unblock = {
    description = "Unblock the Bluetooth radio";
    wantedBy = [ "multi-user.target" ];
    before = [ "bluetooth.service" ];
    after = [ "systemd-rfkill.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
    };
  };

  pear = {
    system.bluetooth.enable = true;
    system.printing.enable = true;

    system.vendor.cpu = "arm";
    system.vendor.gpu = "undefined";

    system.profiles = [ "pearlab" ];
  };
}
