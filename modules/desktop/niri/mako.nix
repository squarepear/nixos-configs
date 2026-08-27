{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.desktop.niri;
  colors = import ./colors.nix;

  wpVol = pkgs.writeShellScriptBin "wp-vol" ''
    set -e

    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

    case "$volume" in
      *"[MUTED]"*) text="Muted" ;;
      *) text="Volume:" ;;
    esac

    volume=$(echo "$volume" | awk '{print $2}')
    volume=$(awk "BEGIN { printf \"%d\", $volume * 100 }")

    notify-send -t 1000 -a 'wp-vol' \
      -h string:x-canonical-private-synchronous:volume \
      -h "int:value:$volume" \
      "$text $volume%"
  '';
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      home.packages = with pkgs; [
        mako
        libnotify
        whitesur-icon-theme
        wpVol
      ];

      services.mako = {
        enable = true;

        settings = {
          font = "CaskaydiaCove Nerd Font 18";
          anchor = "top-right";
          default-timeout = 8000;
          ignore-timeout = false;
          max-history = 10;
          text-alignment = "left";
          markup = true;
          actions = true;

          width = 500;
          height = 180;
          margin = 15;
          padding = 20;
          border-radius = 12;
          border-size = 3;
          icons = true;
          max-icon-size = 64;

          on-button-left = "dismiss";
          on-button-middle = "invoke-default-action";
          on-button-right = "dismiss-all";

          "urgency=low" = {
            "background-color" = "#${colors.base02}";
            "text-color" = "#${colors.base05}";
            "border-color" = "#${colors.base04}";
            "default-timeout" = 4000;
          };

          "urgency=normal" = {
            "background-color" = "#${colors.base00}";
            "text-color" = "#${colors.base05}";
            "border-color" = "#${colors.base0C}";
            "default-timeout" = 8000;
          };

          "urgency=critical" = {
            "background-color" = "#${colors.base08}";
            "text-color" = "#${colors.base00}";
            "border-color" = "#${colors.base08}";
            "default-timeout" = 0;
          };

          "app-name=Discord" = {
            "border-color" = "#${colors.base0D}";
          };

          "app-name=Firefox" = {
            "border-color" = "#${colors.base09}";
          };

          "app-name=wp-vol" = {
            layer = "overlay";
            history = 0;
            anchor = "top-center";
            "group-by" = "app-name";
            format = "<b>%s</b>\\n%b";
          };

          "app-name=volume group-index=0" = {
            invisible = 0;
            default-timeout = 1000;
          };
        };
      };
    });
  };
}
