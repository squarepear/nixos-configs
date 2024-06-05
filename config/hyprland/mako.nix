{ config, lib, ... }:

let
  inherit (config.my.colorScheme) palette;
in
{
  config = lib.mkIf (config.system.gui.wm == "hyprland") {
    my.services = {
      mako = {
        enable = true;

        backgroundColor = "#${palette.base00}";
        borderColor = "#${palette.base02}";
        textColor = "#${palette.base05}";
        font = "CaskaydiaCove Nerd Font 20";
        defaultTimeout = 10000;
      };
    };
  };
}
