{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = [{
      name = "main";
      layer = "top";
      position = "top";
      height = 32;
      output = [
        "DP-1"
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
        "temperature#CPU" = {
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          format = "{temperatureC}°C";
        };
        "clock" = {
          interval = 1;
          format = "{:%a %b %d %I:%M %p}";
        };
      };
    }];

    style = ''
      window#waybar {
        background-color: rgba(43, 48, 59, 0.75);
        color: white;
      }

      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: white;
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
        border-bottom: 3px solid white;
      }

      #pulseaudio {
        padding: 0 10px;
        margin: 0 4px;
      }

      #cpu {
        padding: 0 10px;
        margin: 0 4px;
      }

      #temperature {
        padding: 0 10px;
        margin: 0 4px;
      }

      #clock {
        padding: 0 10px;
        margin: 0 4px;
      }
    '';
  };
} 
