{ config, lib, pkgs, ... }:

let
  inherit (config.my.colorScheme) palette;
  inherit (import ./lib.nix { inherit config pkgs lib; })
    PRIMARY SECONDARY primaryMonitor;
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
            ignore_empty_input = true;
            immediate_render = true;
          };

          # Blur background
          background = {
            monitor = "";
            path = "screenshot";
            blur_passes = 3;
          };

          label = [
            # Time
            {
              monitor = primaryMonitor;
              text = "$TIME12";
              color = "rgb(${palette.base05})";
              font_size = 64;
              font_family = "CaskaydiaCove Nerd Font Bold";
              position = "0, 300";
              halign = "center";
              valign = "center";
            }
            # Date
            {
              monitor = primaryMonitor;
              text = "cmd[update:1000] echo \"$(date '+%A, %B %d')\"";
              color = "rgb(${palette.base04})";
              font_size = 24;
              font_family = "CaskaydiaCove Nerd Font";
              position = "0, 200";
              halign = "center";
              valign = "center";
            }
            # Layout indicator
            {
              monitor = primaryMonitor;
              text = "Layout: $LAYOUT";
              color = "rgb(${palette.base04})";
              font_size = 16;
              font_family = "CaskaydiaCove Nerd Font";
              position = "30, -30";
              halign = "left";
              valign = "bottom";
            }
            # Failed attempts
            {
              monitor = primaryMonitor;
              text = "$FAIL";
              color = "rgb(${palette.base08})";
              font_size = 18;
              font_family = "CaskaydiaCove Nerd Font";
              position = "0, -200";
              halign = "center";
              valign = "center";
            }
          ];

          # Password input field
          input-field = {
            monitor = primaryMonitor;
            size = "400, 60";
            outline_thickness = 3;
            dots_size = 0.3;
            dots_spacing = 0.2;
            dots_center = true;
            dots_rounding = -1;
            outer_color = "rgb(${palette.base02})";
            inner_color = "rgb(${palette.base00})";
            font_color = "rgb(${palette.base05})";
            font_family = "CaskaydiaCove Nerd Font";
            fade_on_empty = true;
            fade_timeout = 2000;
            placeholder_text = "<span foreground=\"##${palette.base04}\">Enter Password...</span>";
            hide_input = false;
            rounding = 12;
            check_color = "rgb(${palette.base0A})";
            fail_color = "rgb(${palette.base08})";
            fail_text = "<span foreground=\"##${palette.base08}\">Authentication Failed</span>";
            capslock_color = "rgb(${palette.base09})";
            numlock_color = "rgb(${palette.base0B})";
            bothlock_color = "rgb(${palette.base0E})";
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
            # Lock screen after 5 minutes
            {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            }
            # Turn off displays after 10 minutes (OLED protection)
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

      wayland.windowManager.hyprland.settings.bind = [
        # Lock screen with hyprlock
        "${PRIMARY}, L, exec, ${lib.getExe pkgs.hyprlock} --immediate"

        # Suspend system
        "${PRIMARY} ${SECONDARY}, L, exec, systemctl suspend"
      ];
    };

    security.pam.services.hyprlock = { };
  };
}
