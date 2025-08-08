{
  config,
  lib,
  pkgs,
  ...
}:

let
  wallpaper = "/home/jeffrey/Pictures/Wallpapers/wallpaper.jpg";
in
{
  config = lib.mkIf (config.pear.desktop.wm == "hyprland") {
    my = {
      xdg.configFile."hypr/hyprpaper.conf" = {
        text = ''
          preload = ${wallpaper}

          wallpaper = ,${wallpaper}
        '';
      };

      wayland.windowManager.hyprland.settings.exec-once = [
        "${lib.getExe pkgs.hyprpaper}"
      ];
    };
  };
}
