{ lib, ... }:

with lib;

{
  options.pear.desktop = {
    enable = mkEnableOption "Desktop Support";

    wm = mkOption {
      type = types.enum [ "hyprland" ];
      default = "hyprland";
    };
  };
}
