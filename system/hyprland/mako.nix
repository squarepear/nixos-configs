{ config, lib, ... }:

let
  inherit (config.my.colorScheme) palette;
in
{
  config = lib.mkIf (config.pear.desktop.wm == "hyprland") {
    my.services = {
      mako = {
        enable = true;

        settings = {
          background-color = "#${palette.base00}";
          border-color = "#${palette.base02}";
          text-color = "#${palette.base05}";
          font = "CaskaydiaCove Nerd Font 20";
          default-timeout = 10000;
        };
      };
    };
  };
}
