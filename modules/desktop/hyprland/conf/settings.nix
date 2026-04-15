{
  config,
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
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      wayland.windowManager.hyprland.settings = {
        monitorv2 = cfg.monitors;

        env = [
          "HYPRCURSOR_THEME,${cursor}"
          "HYPRCURSOR_SIZE,${toString cursorSize}"
          "QT_SCALE_FACTOR,1.5"
          "GTK_DPI_SCALE,1.5"
        ];

        exec-once = [
          "hyprctl setcursor ${cursor} ${toString cursorSize}"
          "${lib.getExe pkgs.wl-clip-persist} --clipboard regular"
        ];

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
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.0";
          animation = [
            "windows, 1, 2, myBezier"
            "windowsOut, 1, 2, default, popin 80%"
            "border, 1, 3, default"
            "fade, 1, 2, default"
            "workspaces, 1, 2, default"
          ];
        };

        dwindle = {
          pseudotile = true;
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

      wayland.windowManager.hyprland.extraConfig = lib.concatStringsSep "\n" (
        lib.flatten [
          (lib.optional cfg.enableSplitMonitorWorkspaces ''
            plugin {
              split-monitor-workspaces {
                count = 10
                keep_focused = 0
                enable_notifications = 0
              }
            }
          '')
        ]
      );
    });
  };
}
