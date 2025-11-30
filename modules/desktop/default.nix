{ config, lib, ... }:

let
  cfg = config.pear.desktop;
in
{
  imports = [
    ./hyprland
  ];

  options.pear.desktop = {
    enable = lib.mkEnableOption "desktop environment support";

    environment = lib.mkOption {
      type = lib.types.enum [
        "none"
        "hyprland"
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
  };
}
