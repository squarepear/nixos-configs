{ pkgs, config, lib, ... }:

let
  terminal = "${pkgs.kitty}/bin/kitty";
  menu = "${pkgs.wofi}/bin/wofi --show run";

  grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";

  date = "${pkgs.coreutils}/bin/date";

  ssdir = "$HOME/Pictures/Screenshots";
in {
  imports = [
    ./mako.nix
    ./waybar.nix    
  ];

  wayland.windowManager.sway = {
    enable = true;
    
    config = {
      terminal = terminal;
      menu = menu;

      modifier = "Mod4"; # Windows key / Command
      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
        left = config.wayland.windowManager.sway.config.left;
        right = config.wayland.windowManager.sway.config.right;
        up = config.wayland.windowManager.sway.config.up;
        down = config.wayland.windowManager.sway.config.down;
      in {
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

        "${mod}+Control+${left}" = "workspace prev";
        "${mod}+Control+${right}" = "workspace next";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";

        "${mod}+Shift+c" = "reload";
      };

      bars = [];
    };
  };
} 

