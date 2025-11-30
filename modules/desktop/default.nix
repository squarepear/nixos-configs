{ config, lib, ... }:

let
  cfg = config.pear.desktop;
in
{
  imports = [
    ./hyprland.nix
  ];

  options.pear.desktop = {
    enable = lib.mkEnableOption "enable desktop environment support";

    environment = lib.mkOption {
      type = lib.types.enum [ "hyprland" ];
      default = "hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    pear.users.defaultGroups = [
      "audio"
      "cdrom"
      "video"
      "input"
    ];
  };
}
