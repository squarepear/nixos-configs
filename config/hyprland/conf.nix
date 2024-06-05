{ config, pkgs, lib, ... }:

let
  inherit (config.my.colorScheme) palette;

  PRIMARY = "SUPER";
  SECONDARY = "SHIFT";
  TERTIARY = "ALT";

  terminal = "${pkgs.kitty}/bin/kitty";
  menu = "${pkgs.rofi}/bin/wofi";
  notifs = "mako";
  idle = "${pkgs.swayidle}/bin/swayidle";
  lock = "${pkgs.swaylock}/bin/swaylock";
  screenshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
  date = "${pkgs.coreutils}/bin/date";
  wallpaper = "${pkgs.hyprpaper}/bin/hyprpaper";

  ssdir = "$HOME/Pictures/Screenshots";
in
{
  config = lib.mkIf (config.system.gui.wm == "hyprland") {
    my = {
      wayland.windowManager.hyprland.extraConfig = ''
        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor=DP-3,3840x2160@60,0x0,1,bitdepth,10
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

            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
            # force_no_accel = true
        }

        exec-once = ${wallpaper}
        exec-once = hyprctl setcursor Numix-Cursor 32

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
          col.border_active=0xff${colors.base0B}
          col.border_inactive=0xff${colors.base04}
        }

        decoration {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            rounding = 10

            blur {
              enabled = true
              size = 3
              passes = 1
            }

            drop_shadow = yes
            shadow_range = 4
            shadow_render_power = 3
            col.shadow = rgba(1a1a1aee)
        }

        animations {
            enabled = yes

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
            no_gaps_when_only = true
        }

        master {
            # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
            new_is_master = true
        }

        gestures {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = on
        }

        misc {
            disable_hyprland_logo = true
            background_color = 0xff000000
            no_direct_scanout = false
            vfr = true
        }

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = ${PRIMARY}, return, exec, kitty
        bind = ${PRIMARY}, Q, killactive,
        bind = ${PRIMARY}, F, fullscreen,
        bind = ${PRIMARY} ${SECONDARY}, F, exec, nemo
        bind = ${PRIMARY}, space, exec, pkill wofi || wofi --show drun
        bind = ${PRIMARY} ${SECONDARY}, space, togglefloating,
        bind = ${PRIMARY}, P, pseudo, # dwindle
        bind = ${PRIMARY}, J, togglesplit, # dwindle
        bind = ${PRIMARY}, R, forcerendererreload,
        bind = ${PRIMARY}, TAB, exec, eww open dashboard --toggle
        bind = ${PRIMARY}, M, exit,

        # Screenshots
        bind = ${PRIMARY}, s, exec, ${screenshot} save screen "${ssdir}/$(${date} +"%Y-%m-%d %H:%M:%S").png"
        bind = ${PRIMARY} ${SECONDARY}, s, exec, ${screenshot} save active "${ssdir}/$(${date} +"%Y-%m-%d %H:%M:%S").png"
        bind = ${PRIMARY} ${TERTIARY}, s, exec, ${screenshot} save area "${ssdir}/$(${date} +"%Y-%m-%d %H:%M:%S").png"

        # Special
        binde =, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        bindle=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        bindl =, XF86AudioMute,        exec, wpctl set-mute   @DEFAULT_AUDIO_SINK@ toggle
        bind  =, XF86AudioPlay,        exec, playerctl play-pause
        bind  =, XF86AudioNext,        exec, playerctl next
        bind  =, XF86AudioPrev,        exec, playerctl previous
        bind  =, XF86Search,           exec, ${menu} --show drun

        # See Mouse Binds section for bindm usage

        # Move focus with mainMod + SHIFT + arrow keys
        bind = ${PRIMARY} ${SECONDARY}, left, movefocus, l
        bind = ${PRIMARY} ${SECONDARY}, right, movefocus, r
        bind = ${PRIMARY} ${SECONDARY}, up, movefocus, u
        bind = ${PRIMARY} ${SECONDARY}, down, movefocus, d

        # Switch workspaces with mainMod + [0-9]
        bind = ${PRIMARY}, 1, workspace, 1
        bind = ${PRIMARY}, 2, workspace, 2
        bind = ${PRIMARY}, 3, workspace, 3
        bind = ${PRIMARY}, 4, workspace, 4
        bind = ${PRIMARY}, 5, workspace, 5
        bind = ${PRIMARY}, 6, workspace, 6
        bind = ${PRIMARY}, 7, workspace, 7
        bind = ${PRIMARY}, 8, workspace, 8
        bind = ${PRIMARY}, 9, workspace, 9
        bind = ${PRIMARY}, 0, workspace, 10

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        bind = ${PRIMARY} ${SECONDARY}, 1, movetoworkspacesilent, 1
        bind = ${PRIMARY} ${SECONDARY}, 2, movetoworkspacesilent, 2
        bind = ${PRIMARY} ${SECONDARY}, 3, movetoworkspacesilent, 3
        bind = ${PRIMARY} ${SECONDARY}, 4, movetoworkspacesilent, 4
        bind = ${PRIMARY} ${SECONDARY}, 5, movetoworkspacesilent, 5
        bind = ${PRIMARY} ${SECONDARY}, 6, movetoworkspacesilent, 6
        bind = ${PRIMARY} ${SECONDARY}, 7, movetoworkspacesilent, 7
        bind = ${PRIMARY} ${SECONDARY}, 8, movetoworkspacesilent, 8
        bind = ${PRIMARY} ${SECONDARY}, 9, movetoworkspacesilent, 9
        bind = ${PRIMARY} ${SECONDARY}, 0, movetoworkspacesilent, 10

        # Move through workspaces with mainMod + arrow keys
        bind = ${PRIMARY}, left, workspace, e-1
        bind = ${PRIMARY}, right, workspace, e+1

        # Scroll through existing workspaces with mainMod + scroll
        bind = ${PRIMARY}, mouse_down, workspace, e-1
        bind = ${PRIMARY}, mouse_up, workspace, e+1

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = ${PRIMARY}, mouse:272, movewindow
        bindm = ${PRIMARY}, mouse:273, resizewindow

        # Window rules
        # Force input for Steam games (fixes some games not getting input)
        windowrulev2 = forceinput,class:^(steam_app_.*)$

        # Force Godot to be tiled
        # windowrulev2 = tile,title:^(Godot)$

        # Firefox Picture-in-Picture floating and sticky
        windowrulev2 = float, title:^(Picture-in-Picture)$
        windowrulev2 = pin, title:^(Picture-in-Picture)$

        env = NIXOS_OZONE_WL=1
        env = QT_QPA_PLATFORM=wayland-egl
        env = MOZ_ENABLE_WAYLAND=1
        env = XCURSOR_SIZE=32
      '';

      gtk = {
        enable = true;

        theme = {
          package = pkgs.whitesur-gtk-theme;
          name = "WhiteSur-Dark";
        };

        iconTheme = {
          package = pkgs.kora-icon-theme;
          name = "kora";
        };

        cursorTheme = {
          package = pkgs.numix-cursor-theme;
          name = "Numix-Cursor";
          size = 32;
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

      qt = {
        enable = true;
        platformTheme = "gtk";
      };

      xdg.mimeApps.defaultApplications = {
        "inode/directory" = "nemo.desktop;code.desktop;";
      };
    };
  };
}
