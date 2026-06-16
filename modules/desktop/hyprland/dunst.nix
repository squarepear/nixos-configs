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
      home.packages = [
        pkgs.dunst
        pkgs.libnotify
      ];

      services.dunst = {
        enable = true;

        iconTheme = {
          package = pkgs.whitesur-icon-theme;
          name = "WhiteSur-dark";
        };

        settings = {
          global = {
            font = "CaskaydiaCove Nerd Font 18";
            frame_width = 3;
            frame_color = "#${colors.base0C}";

            sort = true;
            indicate_hidden = true;
            word_wrap = true;
            ignore_newline = true;
            alignment = "left";
            show_age_threshold = 60;
            sticky_history = true;
            history_length = 10;
            monitor = 0;
            follow = "mouse";
            sticky = false;

            mouse_left_click = "close_current";
            mouse_middle_click = "do_action";
            mouse_right_click = "close_all";

            separator_height = 2;
            separator_color = "frame";
            padding = 20;
            horizontal_padding = 20;
            text_icon_padding = 0;
            line_height = 0;
            geometry = "500x180+15+15";
            shrink = false;
            transparency = 0;
            corner_radius = 12;
          };

          urgency_low = {
            background = "#${colors.base02}";
            foreground = "#${colors.base05}";
            frame_color = "#${colors.base04}";
            timeout = 4;
          };

          urgency_normal = {
            background = "#${colors.base00}";
            foreground = "#${colors.base05}";
            frame_color = "#${colors.base0C}";
            timeout = 8;
          };

          urgency_critical = {
            background = "#${colors.base08}";
            foreground = "#${colors.base00}";
            frame_color = "#${colors.base08}";
            timeout = 0;
          };

          discord = {
            appname = "Discord";
            frame_color = "#${colors.base0D}";
          };

          firefox = {
            appname = "Firefox";
            frame_color = "#${colors.base09}";
          };
        };
      };
    });
  };
}
