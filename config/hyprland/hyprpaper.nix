{ config, lib, pkgs, ... }:

let
  wallpaper = "/home/jeffrey/Pictures/Wallpapers/wallpaper.jpg";
in
{
  config = lib.mkIf (config.system.gui.wm == "hyprland") {
    my = {
      home.packages = with pkgs; [
        hyprpaper
      ];

      xdg.configFile."hypr/hyprpaper.conf" = {
        text = ''
          preload = ${wallpaper}

          wallpaper = ,${wallpaper}
        '';
      };
    };
  };
}
