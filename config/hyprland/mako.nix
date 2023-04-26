{ config, lib, ... }:

let
  inherit (config.my.colorScheme) colors;
in
{
  config = lib.mkIf (config.system.gui.wm == "hyprland") {
    my.services = {
      mako = {
        enable = true;

        backgroundColor = "#${colors.base00}";
        borderColor = "#${colors.base02}";
        textColor = "#${colors.base05}";
        font = "CaskaydiaCove Nerd Font 12";
        defaultTimeout = 15000;
      };
    };
  };
}
