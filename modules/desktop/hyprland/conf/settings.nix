{
  config,
  inputs,
  lib,
  pearlib,
  pkgs,
  unstable,
  ...
}@attrs:

let
  cfg = config.pear.desktop.hyprland;
  colors = import ../colors.nix;
  helpers = import ./helpers.nix attrs;

  inherit (helpers) cursor cursorSize;

  smwPkg =
    inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces;
  smwDir = "${smwPkg}/share/hypr/plugins/split-monitor-workspaces";
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      wayland.windowManager.hyprland.configType = "lua";

      wayland.windowManager.hyprland.extraConfig = lib.optionalString cfg.enableSplitMonitorWorkspaces ''
        package.path = package.path
          .. ";${smwDir}/?.lua"
          .. ";${smwDir}/?/init.lua"
        smw = require("split-monitor-workspaces")

        smw.setup({
          workspace_count = 10,
          keep_focused = false,
          enable_notifications = false,
        })
      '';

      wayland.windowManager.hyprland.settings = {
        env = [
          {
            _args = [
              "HYPRCURSOR_THEME"
              cursor
            ];
          }
          {
            _args = [
              "HYPRCURSOR_SIZE"
              (toString cursorSize)
            ];
          }
          {
            _args = [
              "QT_SCALE_FACTOR"
              "1.5"
            ];
          }
          {
            _args = [
              "GTK_DPI_SCALE"
              "1.5"
            ];
          }
        ];

        exec_cmd = [
          "hyprctl setcursor ${cursor} ${toString cursorSize}"
        ];

        on = [
          {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''
                function()
                  hl.exec_cmd("${lib.getExe pkgs.wl-clip-persist} --clipboard regular")
                end
              '')
            ];
          }
        ];

        monitor = cfg.monitors;

        curve = {
          _args = [
            "myBezier"
            {
              type = "bezier";
              points = [
                [
                  0.05
                  0.9
                ]
                [
                  0.1
                  1.0
                ]
              ];
            }
          ];
        };

        animation = [
          {
            leaf = "windows";
            enabled = true;
            speed = 1;
            bezier = "myBezier";
          }
          {
            leaf = "windowsOut";
            enabled = true;
            speed = 1;
            bezier = "default";
            style = "popin 80%";
          }
          {
            leaf = "border";
            enabled = true;
            speed = 1;
            bezier = "default";
          }
          {
            leaf = "fade";
            enabled = true;
            speed = 1;
            bezier = "default";
          }
          {
            leaf = "workspaces";
            enabled = true;
            speed = 1;
            bezier = "default";
          }
        ];

        config = {
          input = {
            kb_layout = "us";
            follow_mouse = 1;
            touchpad.natural_scroll = true;
          };

          general = {
            gaps_in = 5;
            gaps_out = 0;
            border_size = 2;
            "col.active_border" = "0xff${colors.base0C}";
            "col.inactive_border" = "0xff${colors.base02}";
            layout = "dwindle";
          };

          group = {
            "col.border_active" = "0xff${colors.base0B}";
            "col.border_inactive" = "0xff${colors.base04}";
          };

          decoration = {
            rounding = 10;
            blur = {
              enabled = true;
              size = 3;
              passes = 1;
            };
          };

          animations = {
            enabled = true;
          };

          dwindle = {
            preserve_split = true;
          };

          cursor = {
            no_hardware_cursors = 1;
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            background_color = "0xff000000";
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
          };
        };
      };
    });
  };
}
