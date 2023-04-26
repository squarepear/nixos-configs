{ config, pkgs, lib, ... }:

let
  inherit (config.my.colorScheme) colors;

  font-size = 20;
in
{
  config = lib.mkIf (config.system.gui.wm == "hyprland") {
    my = {
      home.packages = [ pkgs.eww-wayland ];

      xdg.configFile."eww/eww.yuck".text = ''
        (defwindow dashboard
          :monitor 0
          :geometry (geometry
            :x 0
            :y 0
            :anchor "center center")
          :stacking "fg"
          :windowtype "normal"
          :wm-ignore true
          :class "dashboard"
          (dashboard))

        (defwidget dashboard []
          (box :class "dashboard-box" :orientation "h" :space-evenly false
            (box :orientation "v"
              (box :orientation "h" :class "widget-box"
                "Test 1")
              (box :orientation "h" :class "widget-box"
                "Test 2"))
            (music)))

        (defwidget music []
          (box :class "widget-box music-box" :orientation "v" :space-evenly false :spacing 10
            (box :class "album-art" :space-evenly false
              :style `background-image: url("''${music-metadata.artUrl}")`)
            (box :class "song-info" :orientation "v"
              (label :text "''${music-metadata.title}" :limit-width 18)
              (label :class "artist-album" :text "''${music-metadata.artist} - ''${music-metadata.album}" :limit-width 25))
            (box :orientation "h"
              (button :onclick "playerctl previous" "⏮")
              (button :onclick "playerctl play-pause" "⏯")
              (button :onclick "playerctl next" "⏭"))))

        (deflisten music-metadata
          `playerctl metadata -F --format '{"title": "{{ markup_escape(title) }}", "artist": "{{ artist }}", "album": "{{ album }}", "artUrl": "{{ mpris:artUrl }}" }'`)
      '';

      xdg.configFile."eww/eww.scss".text = ''
        * { all: unset; }

        .dashboard-box {
          color: #${colors.base05};
          font-size: ${ toString font-size }px;
          
          .widget-box {
            background-color: #${colors.base00};
            border: 2px solid #${colors.base02};
            border-radius: 10px;
            padding: 16px;
            margin: 5px;
          }
        }

        .music-box {
          .album-art {
            padding: 6em;
            background-size: cover;
            background-repeat: no-repeat;

            border-radius: 10px;
          }

          .song-info {
            .artist-album {
              font-size: ${ toString(font-size - 6) }px;
            }
          }
        }
      '';
    };
  };
}
