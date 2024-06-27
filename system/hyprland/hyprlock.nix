{ config, lib, pkgs, ... }:

let
  PRIMARY = "SUPER";
in
{
  config = lib.mkIf (config.pear.desktop.wm == "hyprland") {
    my = {
      programs.hyprlock = {
        enable = true;

        settings = {
          general = {
            hide_cursor = true;
            grace = 120;
          };

          background = {
            color = "rgba(0, 0, 0, 1.0)";
          };
        };
      };

      services.hypridle = {
        enable = true;

        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };

          listener = [
            {
              timeout = 300;
              on-timeout = "hyprlock";
            }
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

      wayland.windowManager.hyprland.extraConfig = ''
        # Enable hypridle and hyprlock
        bind = ${PRIMARY}, L, exec, ${lib.getExe pkgs.hyprlock} --immediate
        exec-once = ${lib.getExe pkgs.hypridle}
      '';
    };
  };
}
