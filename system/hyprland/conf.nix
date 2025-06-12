{ config, pkgs, lib, ... }:

let
  inherit (config.my.colorScheme) palette;

  PRIMARY = "SUPER";
  SECONDARY = "SHIFT";
  TERTIARY = "ALT";

  terminal = lib.getExe pkgs.kitty;
  editor = lib.getExe pkgs.vscode;
  menu = "${pkgs.tofi}/bin/tofi-drun | xargs uwsm app --";
  notifs = lib.getExe pkgs.mako;
  screenshot = lib.getExe pkgs.sway-contrib.grimshot;
  date = "${pkgs.coreutils}/bin/date";

  cursor = "HyprBibataModernClassicSVG";
  cursorPackage = pkgs.bibata-hyprcursor;
  cursorSize = 24;

  ssdir = "$HOME/Pictures/Screenshots";
in
{
  config = lib.mkIf (config.pear.desktop.wm == "hyprland") {
    my = {
      wayland.windowManager.hyprland.extraConfig = ''
        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor=DP-1,3840x2160@240,3840x0,1, bitdepth,10, cm,wide
        monitor=DP-2,3840x2160@60,0x0,1, bitdepth,10
        monitor=,highrr,auto,1


        # See https://wiki.hyprland.org/Configuring/Keywords/ for more

        # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
        input {
            kb_layout = us
            kb_variant =
            kb_model =
            kb_options =
            kb_rules =

            follow_mouse = 1

            touchpad {
                natural_scroll = yes
            }

            # sensitivity = -0.5 # -1.0 - 1.0, 0 means no modification.
            # accel_profile = flat # flat, adaptive, or none
            # force_no_accel = true
        }

        general {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            gaps_in = 5
            gaps_out = 0
            border_size = 2
            col.active_border=0xff${palette.base0C}
            col.inactive_border=0xff${palette.base02}

            layout = dwindle
        }

        group {
          col.border_active=0xff${palette.base0B}
          col.border_inactive=0xff${palette.base04}
        }

        decoration {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            rounding = 10

            blur {
              enabled = true
              size = 3
              passes = 1
            }
        }

        animations {
            enabled = no

            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

            bezier = myBezier, 0.05, 0.9, 0.1, 1.05

            animation = windows, 1, 7, myBezier
            animation = windowsOut, 1, 7, default, popin 80%
            animation = border, 1, 10, default
            animation = fade, 1, 7, default
            animation = workspaces, 1, 6, default
        }

        dwindle {
            # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
            pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = yes # you probably want this
        }

        master {
            # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
            new_status = master
        }

        gestures {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = on
        }

        misc {
            disable_hyprland_logo = true
            background_color = 0xff000000
            vfr = true
            mouse_move_enables_dpms = true
            key_press_enables_dpms = true
        }

        render {
          cm_fs_passthrough = 2
        }

        experimental {
          xx_color_management_v4 = true
        }

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = ${PRIMARY}, return, exec, uwsm app -- ${terminal}
        bind = ${PRIMARY}, Q, killactive,
        bind = ${PRIMARY}, F, fullscreen,
        bind = ${PRIMARY} ${SECONDARY}, F, exec, uwsm app -- nemo
        bind = ${PRIMARY}, C, exec, uwsm app -- ${editor}
        bind = ${PRIMARY}, space, exec, ${menu}
        bind = ${PRIMARY} ${SECONDARY}, space, togglefloating,
        bind = ${PRIMARY}, P, pseudo, # dwindle
        bind = ${PRIMARY}, J, togglesplit, # dwindle
        bind = ${PRIMARY}, R, forcerendererreload,
        bind = ${PRIMARY}, TAB, exec, eww open dashboard --toggle
        bind = ${PRIMARY}, M, exit,

        # Screenshots, Screen Recording, and Color Picker
        bind = ${PRIMARY}, s, exec, ${screenshot} save screen "${ssdir}/$(${date} +"%Y-%m-%d %H:%M:%S").png"
        bind = ${PRIMARY} ${SECONDARY}, s, exec, ${screenshot} save active "${ssdir}/$(${date} +"%Y-%m-%d %H:%M:%S").png"
        bind = ${PRIMARY} ${TERTIARY}, s, exec, ${screenshot} save area "${ssdir}/$(${date} +"%Y-%m-%d %H:%M:%S").png"
        bind = ${PRIMARY} ${SECONDARY}, C, exec, ${lib.getExe pkgs.hyprpicker} -a

        # Special
        binde =, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        bindle=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        bindl =, XF86AudioMute,        exec, wpctl set-mute   @DEFAULT_AUDIO_SINK@ toggle
        bind  =, XF86AudioPlay,        exec, playerctl play-pause
        bind  =, XF86AudioNext,        exec, playerctl next
        bind  =, XF86AudioPrev,        exec, playerctl previous
        bind  =, XF86Search,           exec, ${menu}

        # See Mouse Binds section for bindm usage

        # Move focus with mainMod + SHIFT + arrow keys
        bind = ${PRIMARY} ${SECONDARY}, left, movefocus, l
        bind = ${PRIMARY} ${SECONDARY}, right, movefocus, r
        bind = ${PRIMARY} ${SECONDARY}, up, movefocus, u
        bind = ${PRIMARY} ${SECONDARY}, down, movefocus, d

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = ${PRIMARY}, mouse:272, movewindow
        bindm = ${PRIMARY}, mouse:273, resizewindow

        # Firefox Picture-in-Picture floating and sticky
        windowrulev2 = float, title:^(Picture-in-Picture)$
        windowrulev2 = pin, title:^(Picture-in-Picture)$

        windowrulev2=idleinhibit focus, class:^(steam_app).*
        windowrulev2=idleinhibit focus, class:^(gamescope).*
        windowrulev2=idleinhibit focus, class:.*(cemu|yuzu|Ryujinx|emulationstation|retroarch).*
        windowrulev2=idleinhibit fullscreen, title:.*(cemu|yuzu|Ryujinx|emulationstation|retroarch).*
        windowrulev2=idleinhibit fullscreen, title:^(.*(Twitch|YouTube|Jellyfin)).*(Firefox).*$
        windowrulev2=idleinhibit focus, title:^(.*(Twitch|YouTube|Jellyfin)).*(Firefox).*$
        windowrulev2=idleinhibit focus, class:^(mpv|.+exe)$
        windowrulev2=immediate, class:^(gamescope|steam_app).*$

        workspace = w[t1], gapsin:0, gapsout:0, border:0, rounding:0

        # Blur tofi
        layerrule = blur, launcher

        # Cursor
        exec-once = hyprctl setcursor ${cursor} ${toString cursorSize}
        env = HYPRCURSOR_THEME,${cursor}
        env = HYPRCURSOR_SIZE,${toString cursorSize}

        # Enable HDR
        debug:full_cm_proto=true
      '';


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
