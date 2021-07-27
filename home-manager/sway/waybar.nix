{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

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
      modules-right = [ "pulseaudio" "cpu" "temperature#CPU" "clock" ];
      modules = {
        "sway/workspaces" = {
          all-outputs = true;
          persistent_workspaces = {
            "1" = []; "2" = []; "3" = []; "4" = []; "5" = [];
          };
        };
        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-icons = {
            headphone = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" ];
          };
        };
        "cpu" = {
          interval = 10;
          format = "{usage}% ";
          max-length = 10;
        };
        "temperature#CPU" = {
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          format = "{temperatureC}°C ";
        };
        "clock" = {
          interval = 1;
          format = "{:%a %b %d %I:%M %p}";
        };
      };
    }];

    style = ''
      * {
        color: white;
        font-family: NotoMono Nerd Font;
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
    '';
  };
} 
