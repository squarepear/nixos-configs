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
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };

          listener = [
            {
              timeout = 300;
              on-timeout = "hyprlock";
            }
            {
              timeout = 1800;
              on-timeout = "systemctl suspend";
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
