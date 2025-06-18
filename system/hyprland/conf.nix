{ config, pkgs, lib, ... }:

let
  inherit (config.my.colorScheme) palette;

  inherit (import ./lib.nix { inherit pkgs lib; })
    PRIMARY SECONDARY TERTIARY
    terminal editor menu screenshot date fileManager colorPicker
    uwsmExec;

  ssdir = "$HOME/Pictures/Screenshots";

  cursor = "HyprBibataModernClassicSVG";
  cursorPackage = pkgs.bibata-hyprcursor;
  cursorSize = 24;
in
{
  config = lib.mkIf (config.pear.desktop.wm == "hyprland") {
    my = {
      wayland.windowManager.hyprland.settings = {
        # Monitor configuration
        monitor = [
          "DP-1,3840x2160@240,3840x0,1#, bitdepth,10, cm,wide"
          "DP-2,3840x2160@60,0x0,1#, bitdepth,10"
          ",highrr,auto,1"
        ];

        # Input configuration
        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          follow_mouse = 1;

          touchpad = {
            natural_scroll = true;
          };

          # sensitivity = -0.5; # -1.0 - 1.0, 0 means no modification.
          # accel_profile = "flat"; # flat, adaptive, or none
          # force_no_accel = true;
        };

        # General window management
        general = {
          gaps_in = 5;
          gaps_out = 0;
          border_size = 2;
          "col.active_border" = "0xff${palette.base0C}";
          "col.inactive_border" = "0xff${palette.base02}";
          layout = "dwindle";
        };

        # Group configuration
        group = {
          "col.border_active" = "0xff${palette.base0B}";
          "col.border_inactive" = "0xff${palette.base04}";
        };

        # Decoration settings
        decoration = {
          rounding = 10;

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
        };

        # Animation settings
        animations = {
          enabled = false;

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        # Dwindle layout settings
        dwindle = {
          pseudotile = true; # master switch for pseudotiling
          preserve_split = true; # you probably want this
        };

        # Master layout settings
        master = {
          new_status = "master";
        };

        # Gesture settings
        gestures = {
          workspace_swipe = true;
        };

        # Miscellaneous settings
        misc = {
          disable_hyprland_logo = true;
          background_color = "0xff000000";
          vfr = true;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };

        # Render settings
        render = {
          cm_fs_passthrough = 2;
          explicit_sync = false;
          explicit_sync_kms = 0;
        };

        # Experimental features
        experimental = {
          xx_color_management_v4 = true;
        };

        # Debug settings
        debug = {
          full_cm_proto = true;
        };

        # Key bindings
        bind = [
          "${PRIMARY}, return, exec, ${uwsmExec terminal}"
          "${PRIMARY}, Q, killactive,"
          "${PRIMARY}, F, fullscreen,"
          "${PRIMARY} ${SECONDARY}, F, exec, ${uwsmExec fileManager}"
          "${PRIMARY}, C, exec, ${uwsmExec editor}"
          "${PRIMARY}, space, exec, ${menu}"
          "${PRIMARY} ${SECONDARY}, space, togglefloating,"
          "${PRIMARY}, P, pseudo," # dwindle
          "${PRIMARY}, J, togglesplit," # dwindle
          "${PRIMARY}, R, forcerendererreload,"
          "${PRIMARY}, M, exit,"

          # Screenshots, Screen Recording, and Color Picker
          "${PRIMARY}, s, exec, ${screenshot} save screen \"${ssdir}/$(${date} +\"%Y-%m-%d %H:%M:%S\").png\""
          "${PRIMARY} ${SECONDARY}, s, exec, ${screenshot} save active \"${ssdir}/$(${date} +\"%Y-%m-%d %H:%M:%S\").png\""
          "${PRIMARY} ${TERTIARY}, s, exec, ${screenshot} save area \"${ssdir}/$(${date} +\"%Y-%m-%d %H:%M:%S\").png\""
          "${PRIMARY} ${SECONDARY}, C, exec, ${colorPicker} -a"

          # Media keys
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86Search, exec, ${menu}"

          # Move focus with mainMod + SHIFT + arrow keys
          "${PRIMARY} ${SECONDARY}, left, movefocus, l"
          "${PRIMARY} ${SECONDARY}, right, movefocus, r"
          "${PRIMARY} ${SECONDARY}, up, movefocus, u"
          "${PRIMARY} ${SECONDARY}, down, movefocus, d"
        ];

        # Volume bindings (special types)
        binde = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ];

        bindle = [
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];

        bindl = [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];

        # Mouse bindings
        bindm = [
          "${PRIMARY}, mouse:272, movewindow"
          "${PRIMARY}, mouse:273, resizewindow"
        ];

        # Window rules
        windowrulev2 = [
          # Firefox Picture-in-Picture floating and sticky
          "float, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"

          # Gaming and media idle inhibit rules
          "idleinhibit focus, class:^(steam_app).*"
          "idleinhibit focus, class:^(gamescope).*"
          "idleinhibit focus, class:.*(cemu|yuzu|Ryujinx|emulationstation|retroarch).*"
          "idleinhibit fullscreen, title:.*(cemu|yuzu|Ryujinx|emulationstation|retroarch).*"
          "idleinhibit fullscreen, title:^(.*(Twitch|YouTube|Jellyfin)).*(Firefox).*$"
          "idleinhibit focus, title:^(.*(Twitch|YouTube|Jellyfin)).*(Firefox).*$"
          "idleinhibit focus, class:^(mpv|.+exe)$"
          "immediate, class:^(gamescope|steam_app).*$"
        ];

        # Workspace rules
        workspace = [
          "w[t1], gapsin:0, gapsout:0, border:0, rounding:0"
        ];

        # Layer rules
        layerrule = [
          "blur, launcher"
        ];

        # Environment variables
        env = [
          "HYPRCURSOR_THEME,${cursor}"
          "HYPRCURSOR_SIZE,${toString cursorSize}"
        ];

        # Startup commands
        "exec-once" = [
          "hyprctl setcursor ${cursor} ${toString cursorSize}"
        ];
      };


      gtk = {
        enable = true;

        theme = {
          package = pkgs.whitesur-gtk-theme;
          name = "WhiteSur-dark-solid";
        };

        iconTheme = {
          package = pkgs.whitesur-icon-theme;
          name = "WhiteSur";
        };

        gtk2.extraConfig = ''
          gtk-application-prefer-dark-theme = 1
          gtk-toolbar-style = "GTK_TOOLBAR_ICONS"
          gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR"
        '';

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
          gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
          gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        };

        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
          gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
          gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        };
      };

      home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = cursorSize;
        gtk.enable = true;
        x11.enable = true;
      };

      home.file.".icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";
      xdg.dataFile."icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";


      qt = {
        enable = true;
        platformTheme.name = "gtk";
      };

      xdg.mimeApps.defaultApplications = {
        "inode/directory" = "nemo.desktop;code.desktop;";
      };
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
