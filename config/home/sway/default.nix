{ config, lib, pkgs, ... }:

let
  terminal = "${pkgs.kitty}/bin/kitty";
  menu = "${pkgs.wofi}/bin/wofi --show drun";
  bar = "${pkgs.waybar}/bin/waybar";

  grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";

  date = "${pkgs.coreutils}/bin/date";

  ssdir = "$HOME/Pictures/Screenshots";
in
{
  imports = [
    ./mako.nix
    ./waybar.nix
    # ./wofi.nix # (Currently Broken)
  ];

  home.packages = with pkgs; lib.mkIf config.system.gui.enable [
    swaylock-effects # Lock screen
    glfw-wayland
    libnotify
    mako # Notification daemon
    qt5.qtwayland
    quintom-cursor-theme
    sway-contrib.grimshot # Screenshot utility
    swaybg # Sway background
    swayidle
    whitesur-gtk-theme
    whitesur-icon-theme
    wl-clipboard # Wayland clipboard manager
    xdg-desktop-portal-wlr # Wayland screen sharing
    xorg.xlsclients
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
          "${mod}+Space" = "exec ${menu}";
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

          "${mod}+Shift+c" = "reload";
        };

      bars = [{ command = bar; }];

      floating.criteria = [
        { title = "^Steam - News*$"; }
        { title = "^UnityEditor.*$"; }
      ];


      window.border = 0;

      gaps = {
        inner = 0;

        smartBorders = "on";
        smartGaps = true;
      };

      output = {
        "*" = {
          bg = "~/Pictures/Wallpapers/wallpaper.jpg fill";
        };

        DP-1 = {
          res = "3840x2160";
          pos = "0 0";
          adaptive_sync = "on";
          # scale = "2";
        };

        HDMI-A-1 = {
          res = "1920x1080";
          pos = "3840 540";
        };
      };
    };

    extraSessionCommands = ''
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
        
      export MOZ_ENABLE_WAYLAND="1"

      # export SDL_VIDEODRIVER=wayland
        
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';

    extraConfig = ''
      for_window [shell=".*"] inhibit_idle fullscreen
      # Auto lock (this does not configure sleeping)
      set $lock 'swaylock --indicator --indicator-radius 120 --indicator-thickness 8 --clock --timestr "%I:%M %p" --screenshots --effect-scale 0.5 --effect-blur 8x3 --effect-scale 2 --fade-in 0.2'
      exec ${pkgs.swayidle}/bin/swayidle -w \
        timeout 300 '$lock' \
        # timeout 310 'systemctl suspend' \
        timeout 280 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
        before-sleep '$lock'
      # Cursor
      seat seat0 xcursor_theme Quintom_Ink 32
    '';
  };
}
