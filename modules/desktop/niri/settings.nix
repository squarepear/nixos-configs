{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.desktop.niri;
  displayCfg = config.pear.desktop.displays;
  colors = import ./colors.nix;

  TERMINAL = lib.getExe pkgs.kitty;
  LAUNCHER = "${lib.getExe pkgs.tofi}-drun";
  FILE_MANAGER = lib.getExe pkgs.nemo;
  EDITOR = lib.getExe pkgs.vscode;

  mkOutput =
    display:
    {
      mode = {
        width = display.width;
        height = display.height;
        refresh = display.refreshRate;
      };
      position = {
        x = display.x;
        y = display.y;
      };
      scale = display.scale;
      focus-at-startup = display.primary;
    }
    // lib.optionalAttrs (display.rotation != 0) {
      transform = {
        rotation = display.rotation;
      };
    };

  outputs = lib.listToAttrs (
    map (d: {
      name = d.output;
      value = mkOutput d;
    }) displayCfg
  );

  # Volume helper used by multiple XF86 keys.
  wpctlVolume = delta: [
    "sh"
    "-c"
    "wpctl set-volume @DEFAULT_AUDIO_SINK@ ${delta} && wp-vol"
  ];
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      programs.niri.settings = {
        inherit outputs;

        screenshot-path = "~/Pictures/Screenshots/%Y-%m-%dT%H:%M:%S.png";

        spawn-at-startup = [
          { argv = [ (lib.getExe pkgs.mako) ]; }
        ];

        environment = {
          QT_QPA_PLATFORM = "wayland";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          MOZ_ENABLE_WAYLAND = "1";
          NIXOS_OZONE_WL = "1";
        };

        animations = {
          enable = true;
          window-open = {
            enable = true;
            kind.easing = {
              curve = "cubic-bezier";
              curve-args = [
                0.05
                0.9
                0.1
                1.0
              ];
              duration-ms = 250;
            };
          };
          window-close = {
            enable = true;
            kind.easing = {
              curve = "cubic-bezier";
              curve-args = [
                0.05
                0.9
                0.1
                1.0
              ];
              duration-ms = 200;
            };
          };
          window-movement = {
            enable = true;
            kind.easing = {
              curve = "cubic-bezier";
              curve-args = [
                0.05
                0.9
                0.1
                1.0
              ];
              duration-ms = 250;
            };
          };
          window-resize = {
            enable = true;
            kind.easing = {
              curve = "cubic-bezier";
              curve-args = [
                0.05
                0.9
                0.1
                1.0
              ];
              duration-ms = 250;
            };
          };
          workspace-switch = {
            enable = true;
            kind.easing = {
              curve = "cubic-bezier";
              curve-args = [
                0.05
                0.9
                0.1
                1.0
              ];
              duration-ms = 250;
            };
          };
        };

        blur = {
          enable = true;
          passes = 1;
          offset = 3;
        };

        layout = {
          gaps = 5;
          background-color = "#${colors.base00}";

          border = {
            enable = true;
            width = 2;
            active."color" = "#${colors.base0C}";
            inactive."color" = "#${colors.base02}";
          };

          focus-ring.enable = false;

          default-column-width = {
            proportion = 1.0 / 2.0;
          };

          preset-column-widths = [
            { proportion = 1.0 / 6.0; }
            { proportion = 1.0 / 4.0; }
            { proportion = 1.0 / 3.0; }
            { proportion = 1.0 / 2.0; }
            { proportion = 2.0 / 3.0; }
            { proportion = 3.0 / 4.0; }
            { proportion = 5.0 / 6.0; }
          ];
        };

        cursor = {
          theme = "Bibata-Modern-Classic";
          size = 24;
          hide-when-typing = true;
        };

        input = {
          keyboard.xkb.layout = "us";
          mouse.accel-speed = 1.0;
          focus-follows-mouse.enable = true;
          warp-mouse-to-focus = {
            enable = true;
            mode = "center-xy";
          };
          touchpad = {
            tap = true;
            dwt = true;
            natural-scroll = true;
          };
        };

        prefer-no-csd = true;
        clipboard.disable-primary = true;

        xwayland-satellite = {
          enable = true;
          path = lib.getExe pkgs.xwayland-satellite-unstable;
        };

        window-rules = [
          {
            matches = lib.singleton { };
            clip-to-geometry = true;
            geometry-corner-radius = {
              top-left = 10.0;
              top-right = 10.0;
              bottom-left = 10.0;
              bottom-right = 10.0;
            };
          }

          {
            matches = [
              {
                app-id = "code";
              }
            ];
            open-maximized = true;
          }

          {
            matches = [
              {
                app-id = "firefox$";
                title = "^Picture-in-Picture$";
              }
            ];
            open-floating = true;
          }

          {
            matches = [
              {
                app-id = "steam";
                title = "^notificationtoasts";
              }
            ];
            open-focused = false;
            default-floating-position = {
              relative-to = "bottom-right";
              x = 8;
              y = 8;
            };
            block-out-from = "screencast";
          }
        ];

        binds = {
          # Apps
          "Mod+Return".action.spawn = TERMINAL;
          "Mod+Space".action.spawn = LAUNCHER;
          "XF86Search".action.spawn = LAUNCHER;
          "Mod+Shift+F".action.spawn = FILE_MANAGER;
          "Mod+C".action.spawn = EDITOR;
          "Mod+Shift+L".action.spawn = [
            "systemctl"
            "suspend"
          ];

          # Window management
          "Mod+O".action.show-hotkey-overlay = [ ];
          "Mod+Q".action.close-window = [ ];
          # "Mod+F".action.maximize-column = [ ];
          "Mod+F".action.fullscreen-window = [ ];
          "Mod+R".action.switch-preset-column-width = [ ];
          "Mod+V".action.switch-focus-between-floating-and-tiling = [ ];
          "Mod+Shift+V".action.toggle-window-floating = [ ];

          # Session
          "Mod+Shift+E".action.quit = [ ];
          "Mod+Shift+P".action.power-off-monitors = [ ];

          # Screenshots
          "Mod+S".action.screenshot-screen = [ ];
          "Mod+Shift+S".action.screenshot-window = [ ];
          "Mod+Ctrl+S".action.screenshot = [ ];
          "Print".action.screenshot-screen = [ ];
          "Mod+Print".action.screenshot-window = [ ];

          # Focus / nav
          "Mod+Left".action.focus-column-left = [ ];
          "Mod+Right".action.focus-column-right = [ ];
          "Mod+Up".action.focus-window-up = [ ];
          "Mod+Down".action.focus-window-down = [ ];

          # Move column/window
          "Mod+Ctrl+Left".action.move-column-left = [ ];
          "Mod+Ctrl+Right".action.move-column-right = [ ];
          "Mod+Ctrl+Up".action.move-window-up = [ ];
          "Mod+Ctrl+Down".action.move-window-down = [ ];

          # Focus monitor
          "Mod+Shift+Left".action.focus-monitor-left = [ ];
          "Mod+Shift+Right".action.focus-monitor-right = [ ];
          "Mod+Shift+Up".action.focus-monitor-up = [ ];
          "Mod+Shift+Down".action.focus-monitor-down = [ ];

          # Move to monitor
          "Mod+Shift+Ctrl+Left".action.move-window-to-monitor-left = [ ];
          "Mod+Shift+Ctrl+Right".action.move-window-to-monitor-right = [ ];
          "Mod+Shift+Ctrl+Up".action.move-window-to-monitor-up = [ ];
          "Mod+Shift+Ctrl+Down".action.move-window-to-monitor-down = [ ];

          # Workspace focus 1..9 and move
        }
        // builtins.listToAttrs (
          lib.concatMap (n: [
            {
              name = "Mod+${toString n}";
              value.action.focus-workspace = n;
            }
            {
              name = "Mod+Shift+${toString n}";
              value.action.move-window-to-workspace = n;
            }
          ]) (lib.range 1 9)
        )
        // {
          # Workspace up/down via vim keys and mouse wheel
          "Mod+U".action.focus-workspace-up = [ ];
          "Mod+I".action.focus-workspace-down = [ ];
          "Mod+Ctrl+U".action.move-window-to-workspace-up = [ ];
          "Mod+Ctrl+I".action.move-window-to-workspace-down = [ ];
          "Mod+WheelScrollUp".action.focus-workspace-up = [ ];
          "Mod+WheelScrollDown".action.focus-workspace-down = [ ];

          # Media keys — work while locked
          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action.spawn = wpctlVolume "0.05+";
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action.spawn = wpctlVolume "0.05-";
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action.spawn = [
              "sh"
              "-c"
              "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && wp-vol"
            ];
          };

          "XF86AudioPlay" = {
            allow-when-locked = true;
            action.spawn = [
              "playerctl"
              "play-pause"
            ];
          };
          "XF86AudioPause" = {
            allow-when-locked = true;
            action.spawn = [
              "playerctl"
              "play-pause"
            ];
          };
          "XF86AudioStop" = {
            allow-when-locked = true;
            action.spawn = [
              "playerctl"
              "stop"
            ];
          };
          "XF86AudioPrev" = {
            allow-when-locked = true;
            action.spawn = [
              "playerctl"
              "previous"
            ];
          };
          "XF86AudioNext" = {
            allow-when-locked = true;
            action.spawn = [
              "playerctl"
              "next"
            ];
          };

          "XF86MonBrightnessUp" = {
            allow-when-locked = true;
            action.spawn = [
              "brightnessctl"
              "set"
              "5%+"
            ];
          };
          "XF86MonBrightnessDown" = {
            allow-when-locked = true;
            action.spawn = [
              "brightnessctl"
              "set"
              "5%-"
            ];
          };
        };

        layer-rules = [
          {
            matches = [ { namespace = "^mako$"; } ];

            block-out-from = "screencast";
          }
        ];
      };

      home.packages = with pkgs; [
        libnotify
        playerctl
        brightnessctl
      ];

      programs.tofi = {
        enable = true;
        settings = {
          drun-launch = true;
          terminal = TERMINAL;
        };
      };
    });
  };
}
