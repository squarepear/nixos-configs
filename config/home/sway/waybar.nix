{ config, ... }:

{
  programs.waybar = {
    enable = false; # config.wayland.windowManager.sway.enable;

    settings = [{
      name = "main";
      layer = "top";
      position = "top";
      height = 56;
      output = [
        "DP-1"
        # "HDMI-A-1"
      ];
      modules-left = [ "sway/workspaces" ];
      modules-center = [ "sway/window" ];
      modules-right = [ "pulseaudio" "memory" "cpu" "temperature#CPU" "clock" "custom/power" ];
      modules = {
        "sway/workspaces" = {
          all-outputs = true;
          persistent_workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };
        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            default = [ "" "" ];
            headphone = "";
          };
        };
        "memory" = {
          interval = 5;
          format = "{used:0.01f} GB ";
          max-length = 10;
        };
        "cpu" = {
          interval = 5;
          format = "{usage}% ";
          max-length = 10;
        };
        "temperature#CPU" = {
          interval = 5;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          format = "{temperatureC}°C ";
        };
        "clock" = {
          interval = 1;
          format = "{:%a %b %d %I:%M %p}";
        };
        "custom/power" = {
          format = "⏻";
          on-click = "${pkgs.rofi}/bin/rofi -show power-menu -modi power-menu:rofi-power-menu";
          tooltip = false;
        };
      };
    }];

    style = ''
      * {
        color: white;
        font-family: Ubuntu Mono Nerd Font;
        font-size: 20px;
      }
      window#waybar {
        background-color: rgba(43, 48, 59, 0.75);
      }
      #workspaces button {
        padding: 0 20px;
        background-color: transparent;
        border: 0px;
        border-radius: 0px;
        border-bottom: 3px solid transparent;
      }
      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.25);
        box-shadow: inherit;
        border: 0px;
        border-bottom: 3px solid white;
      }
      #workspaces button.focused {
        background: rgba(255, 255, 255, 0.1);
        border-bottom: 3px solid white;
      }
      #pulseaudio {
        padding: 0 20px;
        margin: 0 6px;
      }
      #memory {
        padding: 0 20px;
        margin: 0 6px;
      }
      #cpu {
        padding: 0 20px;
        margin: 0 6px;
      }
      #temperature {
        padding: 0 20px;
        margin: 0 6px;
      }
      #clock {
        padding: 0 20px;
        margin: 0 6px;
      }
      #custom-power {
        padding: 0 20px;
        padding-right: 30px;
        margin: 0 6px;
      }
    '';
  };
}
