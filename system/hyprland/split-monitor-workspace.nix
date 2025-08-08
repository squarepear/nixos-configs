{
  inputs,
  pkgs,
  ...
}@attrs:

let
  inherit (import ./lib.nix attrs)
    PRIMARY
    SECONDARY
    TERTIARY
    ;

  plugin = inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces;
in
{
  my.wayland.windowManager.hyprland.plugins = [
    plugin
  ];

  my.wayland.windowManager.hyprland.settings.bind = [
    # Switch workspaces with mainMod + [0-9]
    "${PRIMARY}, 1, split-workspace, 1"
    "${PRIMARY}, 2, split-workspace, 2"
    "${PRIMARY}, 3, split-workspace, 3"
    "${PRIMARY}, 4, split-workspace, 4"
    "${PRIMARY}, 5, split-workspace, 5"
    "${PRIMARY}, 6, split-workspace, 6"
    "${PRIMARY}, 7, split-workspace, 7"
    "${PRIMARY}, 8, split-workspace, 8"
    "${PRIMARY}, 9, split-workspace, 9"
    "${PRIMARY}, 0, split-workspace, 10"

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    "${PRIMARY} ${SECONDARY}, 1, split-movetoworkspacesilent, 1"
    "${PRIMARY} ${SECONDARY}, 2, split-movetoworkspacesilent, 2"
    "${PRIMARY} ${SECONDARY}, 3, split-movetoworkspacesilent, 3"
    "${PRIMARY} ${SECONDARY}, 4, split-movetoworkspacesilent, 4"
    "${PRIMARY} ${SECONDARY}, 5, split-movetoworkspacesilent, 5"
    "${PRIMARY} ${SECONDARY}, 6, split-movetoworkspacesilent, 6"
    "${PRIMARY} ${SECONDARY}, 7, split-movetoworkspacesilent, 7"
    "${PRIMARY} ${SECONDARY}, 8, split-movetoworkspacesilent, 8"
    "${PRIMARY} ${SECONDARY}, 9, split-movetoworkspacesilent, 9"
    "${PRIMARY} ${SECONDARY}, 0, split-movetoworkspacesilent, 10"

    # Move through workspaces with mainMod + arrow keys
    "${PRIMARY}, left, split-workspace, e-1"
    "${PRIMARY}, right, split-workspace, e+1"

    # Scroll through existing workspaces with mainMod + scroll
    "${PRIMARY}, mouse_down, split-workspace, e-1"
    "${PRIMARY}, mouse_up, split-workspace, e+1"

    # Move active window to other monitor with mainMod + TERTIARY + arrow keys
    "${PRIMARY} ${TERTIARY}, left, split-changemonitor, prev"
    "${PRIMARY} ${TERTIARY}, right, split-changemonitor, next"
  ];

  my.wayland.windowManager.hyprland.extraConfig = ''
    plugin {
        split-monitor-workspaces {
            count = 10
            keep_focused = 0
            enable_notifications = 0
        }
    }
  '';
}
