{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.system.printing;
in
{
  options.pear.system.printing = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "desktop";
      description = "Enable printing support (CUPS).";
    };

    enableAvahi = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Avahi/mDNS to discover network printers.";
    };

    drivers = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        brlaser
        gutenprint
        cups-zj-58
      ];
      description = "Additional CUPS printer drivers to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
    services.printing.drivers = cfg.drivers;

    # For network discovery of printers. (Your networking module may also enable Avahi;
    # setting it twice is fine, but we keep it behind a toggle.)
    services.avahi.enable = lib.mkIf cfg.enableAvahi true;
    services.avahi.nssmdns4 = lib.mkIf cfg.enableAvahi true;

    # Add lp group to default groups so users can manage printers
    pear.users.defaultGroups = [ "lp" ];

    pear.system.impermanence.persist.directories = [
      "/var/lib/cups"
    ];
  };
}
