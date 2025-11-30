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
        pkgs.mako
        pkgs.libnotify
      ];

      services.mako = {
        enable = true;

        settings = {
          background-color = "#${colors.base00}";
          border-color = "#${colors.base0C}";
          text-color = "#${colors.base05}";
          progress-color = "over #${colors.base03}";

          font = "CaskaydiaCove Nerd Font 18";
          icon-path = "${pkgs.whitesur-icon-theme}/share/icons/WhiteSur-dark";

          width = 500;
          height = 180;
          margin = "15";
          padding = "20";
          border-size = 3;
          border-radius = 12;

          anchor = "top-right";

          default-timeout = 8000;
          ignore-timeout = false;
          max-history = 10;
          sort = "-time";

          icons = true;
          max-icon-size = 64;
          icon-location = "left";

          group-by = "app-name";
          actions = true;

          "urgency=critical" = {
            background-color = "#${colors.base08}";
            border-color = "#${colors.base08}";
            text-color = "#${colors.base00}";
            default-timeout = 0;
          };

          "urgency=low" = {
            background-color = "#${colors.base02}";
            border-color = "#${colors.base04}";
            default-timeout = 4000;
          };

          "app-name=Discord".border-color = "#${colors.base0D}";
          "app-name=Firefox".border-color = "#${colors.base09}";
        };
      };
    });
  };
}
