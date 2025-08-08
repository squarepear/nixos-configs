{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.my.colorScheme) palette;
in
{
  config = lib.mkIf (config.pear.desktop.wm == "hyprland") {
    my.services = {
      mako = {
        enable = true;

        settings = {
          # Appearance
          background-color = "#${palette.base00}";
          border-color = "#${palette.base0C}";
          text-color = "#${palette.base05}";
          progress-color = "over #${palette.base03}";

          # Typography
          font = "CaskaydiaCove Nerd Font 14";

          # Icon theme
          icon-path = "${pkgs.whitesur-icon-theme}/share/icons/WhiteSur-dark";

          # Layout
          width = 500;
          height = 180;
          margin = "15";
          padding = "20";
          border-size = 3;
          border-radius = 12;

          # Positioning
          anchor = "top-right";

          # Behavior
          default-timeout = 8000;
          ignore-timeout = false;
          max-history = 10;
          sort = "-time";

          # Icons
          icons = true;
          max-icon-size = 64;
          icon-location = "left";

          # Grouping
          group-by = "app-name";

          # Actions
          actions = true;

          # Critical notifications
          "urgency=critical" = {
            background-color = "#${palette.base08}";
            border-color = "#${palette.base08}";
            text-color = "#${palette.base00}";
            default-timeout = 0;
          };

          # Low priority notifications
          "urgency=low" = {
            background-color = "#${palette.base02}";
            border-color = "#${palette.base04}";
            default-timeout = 4000;
          };

          # App-specific styling
          "app-name=Discord" = {
            border-color = "#${palette.base0D}";
          };

          "app-name=Firefox" = {
            border-color = "#${palette.base09}";
          };
        };
      };
    };
  };
}
