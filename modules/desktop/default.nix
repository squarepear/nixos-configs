{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.desktop;
in
{
  imports = [
    ./niri

    ./displays.nix
  ];

  options.pear.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "desktop";
    };

    environment = lib.mkOption {
      type = lib.types.enum [
        "none"
        "niri"
      ];
      default = "none";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable GVFS for network shares and trash support
    services.gvfs.enable = true;

    pear.users.defaultGroups = [
      "audio"
      "cdrom"
      "video"
      "input"
    ];

    assertions = [
      {
        assertion = cfg.environment != "none";
        message = "pear.desktop.environment must be set when desktop is enabled.";
      }
    ];
  };
}
