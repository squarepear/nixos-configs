{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.desktop.hyprland;
  colors = import ./colors.nix;
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            hide_cursor = true;
            grace = 120;
            ignore_empty_input = true;
            immediate_render = true;
          };

          background = {
            monitor = "";
            path = "screenshot";
            blur_passes = 3;
          };

          label = [
            {
              monitor = cfg.primaryMonitor;
              text = "$TIME12";
              color = "rgb(${colors.base05})";
              font_size = 64;
              font_family = "CaskaydiaCove Nerd Font Bold";
              position = "0, 300";
              halign = "center";
              valign = "center";
            }
            {
              monitor = cfg.primaryMonitor;
              text = "cmd[update:1000] echo \"$(date '+%A, %B %d')\"";
              color = "rgb(${colors.base04})";
              font_size = 24;
              font_family = "CaskaydiaCove Nerd Font";
              position = "0, 200";
              halign = "center";
              valign = "center";
            }
            {
              monitor = cfg.primaryMonitor;
              text = "Layout: $LAYOUT";
              color = "rgb(${colors.base04})";
              font_size = 16;
              font_family = "CaskaydiaCove Nerd Font";
              position = "30, -30";
              halign = "left";
              valign = "bottom";
            }
            {
              monitor = cfg.primaryMonitor;
              text = "$FAIL";
              color = "rgb(${colors.base08})";
              font_size = 18;
              font_family = "CaskaydiaCove Nerd Font";
              position = "0, -200";
              halign = "center";
              valign = "center";
            }
          ];

          input-field = {
            monitor = cfg.primaryMonitor;
            size = "400, 60";
            outline_thickness = 3;
            dots_size = 0.3;
            dots_spacing = 0.2;
            dots_center = true;
            dots_rounding = -1;
            outer_color = "rgb(${colors.base02})";
            inner_color = "rgb(${colors.base00})";
            font_color = "rgb(${colors.base05})";
            font_family = "CaskaydiaCove Nerd Font";
            fade_on_empty = true;
            fade_timeout = 2000;
            placeholder_text = "<span foreground=\"##${colors.base04}\">Enter Password...</span>";
            hide_input = false;
            rounding = 12;
            check_color = "rgb(${colors.base0A})";
            fail_color = "rgb(${colors.base08})";
            fail_text = "<span foreground=\"##${colors.base08}\">Authentication Failed</span>";
            capslock_color = "rgb(${colors.base09})";
            numlock_color = "rgb(${colors.base0B})";
            bothlock_color = "rgb(${colors.base0E})";
            invert_numlock = false;
            swap_font_color = false;
            position = "0, -120";
            halign = "center";
            valign = "center";
            zindex = 0;
          };
        };
      };

      services.hypridle = {
        enable = true;
        settings = {
          general = {
            ignore_dbus_inhibit = false;
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

      # Helper binary for quick access (optional, used by the old config).
      home.packages = [ pkgs.hyprlock ];
    });

    # Needed for hyprlock.
    security.pam.services.hyprlock = { };
  };
}
