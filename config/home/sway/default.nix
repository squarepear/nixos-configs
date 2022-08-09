{ config, lib, pkgs, ... }:

let
  terminal = "${pkgs.kitty}/bin/kitty";
  menu = "${pkgs.rofi}/bin/rofi -show";
  notifs = "mako";
  idle = "${pkgs.swayidle}/bin/swayidle";
  lock = "${pkgs.swaylock}/bin/swaylock";
  grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
  xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
  date = "${pkgs.coreutils}/bin/date";

  ssdir = "$HOME/Pictures/Screenshots";
in
{
  imports = [
    ./eww.nix
    ./mako.nix
    ./waybar.nix
    ./rofi.nix
    ./swaylock.nix
  ];

  home.packages = with pkgs; lib.mkIf config.system.gui.enable [
    glfw-wayland
    libnotify
    mako # Notification daemon
    qt5.qtwayland
    quintom-cursor-theme
    sway-contrib.grimshot # Screenshot utility
    swaybg # Sway background
    swayidle
    swaylock # Lock screen
    whitesur-gtk-theme
    whitesur-icon-theme
    playerctl
    wl-clipboard # Wayland clipboard manager
    xarchiver
    xdg-utils
    xdg-desktop-portal-wlr # Wayland screen sharing
    xorg.xlsclients
    xorg.xrandr
  ];

  wayland.windowManager.sway = {
    enable = config.system.gui.enable;
    xwayland = true;

    wrapperFeatures.gtk = true;

    config = {
      terminal = terminal;
      menu = menu;

      modifier = "Mod4"; # Windows key / Command
      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
          left = config.wayland.windowManager.sway.config.left;
          right = config.wayland.windowManager.sway.config.right;
          up = config.wayland.windowManager.sway.config.up;
          down = config.wayland.windowManager.sway.config.down;
        in
        {
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+Space" = "exec ${menu} drun";
          "${mod}+q" = "kill";

          "${mod}+s" = ''
            exec ${grimshot} save screen "${ssdir}/$(${date} +"%Y-%m-%d %H:%M:%S").png"
          '';
          "${mod}+Shift+s" = ''
            exec ${grimshot} save active "${ssdir}/$(${date} +"%Y-%m-%d %H:%M:%S").png"
          '';
          "${mod}+Alt+s" = ''
            exec ${grimshot} save area "${ssdir}/$(${date} +"%Y-%m-%d %H:%M:%S").png"
          '';

          "${mod}+f" = "fullscreen toggle";

          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${right}" = "move right";

          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";

          "${mod}+Control+${left}" = "workspace prev_on_output";
          "${mod}+Control+${right}" = "workspace next_on_output";

          "${mod}+Control+Left" = "workspace prev_on_output";
          "${mod}+Control+Right" = "workspace next_on_output";

          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";

          "${mod}+Alt+Left" = "resize shrink width";
          "${mod}+Alt+Right" = "resize grow width";
          "${mod}+Alt+Down" = "resize shrink height";
          "${mod}+Alt+Up" = "resize grow height";

          "${mod}+Shift+Space" = "floating toggle";

          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86Search" = "exec ${menu} drun";

          "${mod}+Shift+c" = "reload";
        };

      bars = [ ];

      floating.criteria = [
        { title = "^Steam - News*$"; }
        { title = "^UnityEditor.*$"; }
        { instance = "^Godot_Engine$"; } # transient_for = "^.*$"; }
      ];


      window.border = 0;

      gaps = {
        inner = 0;

        smartBorders = "on";
        smartGaps = true;
      };

      output = {
        "*" = {
          bg = "#000000 solid_color";
        };

        #  
        #  Monitor Layout
        #  
        #  ┌─────╥──────────────────┐
        #  │      ║                      │
        #  │      ║                      │
        #  │  28" ║          48"         │
        #  │      ║                      │
        #  │      ║                      │
        #  └─────╨──────────────────┘

        HDMI-A-1 = {
          res = "3840x2160@120Hz";
          # scale = "2";
          pos = "1080 0";
          adaptive_sync = "on";
          render_bit_depth = "10";
        };

        DP-3 = {
          res = "3840x2160@60Hz";
          scale = "2";
          pos = "0 98";
          transform = "270";
          adaptive_sync = "on";
          render_bit_depth = "10";
        };
      };
    };

    extraConfig = ''
      # Set correct primary monitor for xwayland
      exec ${xrandr} --output XWAYLAND1 --primary

      # Don't idle if application is in fullscreen
      for_window [shell=".*"] inhibit_idle fullscreen

      # Auto lock
      exec ${idle} -w \
        timeout 120 '${lock} -f' \
        timeout 180 'swaymsg "output * dpms off"' \
             resume 'swaymsg "output * dpms on"' \
        before-sleep '${lock} -f'

      # Cursor
      seat seat0 xcursor_theme Quintom_Ink 32

      # Enable notification daemon
      exec ${notifs}
    '';
  };

  home.sessionVariables = {
    XDG_SESSION_TYPE="wayland";
    XDG_CURRENT_DESKTOP="sway";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "x11";
    QT_QPA_PLATFORM = "xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";

    TERMINAL = "${terminal}";
    EDITOR = "${pkgs.neovim}/bin/nvim";
    BROWSER = "${pkgs.firefox}/bin/firefox";
    FILEBROWSER = "${pkgs.pcmanfm}/bin/pcmanfm";
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
    };

    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}
