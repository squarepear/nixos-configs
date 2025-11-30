{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.system.bluetooth;

  desktopEnabled = pearlib.profileEnabled "desktop";
in
{
  options.pear.system.bluetooth = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = desktopEnabled;
      description = "Enable Bluetooth support.";
    };

    enableBlueman = lib.mkOption {
      type = lib.types.bool;
      default = desktopEnabled;
      description = "Enable Blueman (GTK bluetooth manager).";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;

    services.blueman.enable = cfg.enableBlueman;
  };
}
