{
  inputs,
  pkgs,
  ...
}@attrs:

let
  inherit (import ./lib.nix attrs)
    PRIMARY
    ;
in
{
  my.wayland.windowManager.hyprland.plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
    # hyprbars
    hyprexpo
    # hyprtrails
    # hyprwinwrap
  ];

  my.wayland.windowManager.hyprland.settings.bind = [
    "${PRIMARY}, grave, hyprexpo:expo, toggle" # can be: toggle, off/disable or on/enable
  ];

  my.wayland.windowManager.hyprland.extraConfig = ''
    plugin {
        hyprexpo {
            columns = 3
            gap_size = 5
            bg_col = rgb(000000)
            workspace_method = center current # [center/first] [workspace] e.g. first 1 or center m+1

            enable_gesture = true # laptop touchpad
            gesture_fingers = 3  # 3 or 4
            gesture_distance = 300 # how far is the "max"
            gesture_positive = true # positive = swipe down. Negative = swipe up.
        }
    }
  '';
}
