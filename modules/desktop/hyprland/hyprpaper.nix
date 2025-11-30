{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      # TODO: Add https://github.com/nikolaizombie1/waytrogen
      home.packages = [ pkgs.hyprpaper ];

      xdg.configFile."hypr/hyprpaper.conf".text = ''
        preload = ${toString cfg.wallpaper}

        wallpaper = ,${toString cfg.wallpaper}
      '';
    });
  };
}
