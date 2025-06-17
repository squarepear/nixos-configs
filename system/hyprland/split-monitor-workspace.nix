{ inputs, lib, pkgs, ... }:

let
  inherit (import ./lib.nix { inherit pkgs lib; })
    PRIMARY SECONDARY TERTIARY;

  plugin = inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces;
in
{
  my.wayland.windowManager.hyprland.plugins = [
    plugin
  ];

  my.wayland.windowManager.hyprland.extraConfig = ''
    plugin {
        split-monitor-workspaces {
            count = 10
            keep_focused = 0
            enable_notifications = 0
        }
    }

    $mainMod = SUPER
    # Switch workspaces with mainMod + [0-5]
    bind = ${PRIMARY}, 1, split-workspace, 1
    bind = ${PRIMARY}, 2, split-workspace, 2
    bind = ${PRIMARY}, 3, split-workspace, 3
    bind = ${PRIMARY}, 4, split-workspace, 4
    bind = ${PRIMARY}, 5, split-workspace, 5
    bind = ${PRIMARY}, 6, split-workspace, 6
    bind = ${PRIMARY}, 7, split-workspace, 7
    bind = ${PRIMARY}, 8, split-workspace, 8
    bind = ${PRIMARY}, 9, split-workspace, 9
    bind = ${PRIMARY}, 0, split-workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-5]
    bind = ${PRIMARY} ${SECONDARY}, 1, split-movetoworkspacesilent, 1
    bind = ${PRIMARY} ${SECONDARY}, 2, split-movetoworkspacesilent, 2
    bind = ${PRIMARY} ${SECONDARY}, 3, split-movetoworkspacesilent, 3
    bind = ${PRIMARY} ${SECONDARY}, 4, split-movetoworkspacesilent, 4
    bind = ${PRIMARY} ${SECONDARY}, 5, split-movetoworkspacesilent, 5
    bind = ${PRIMARY} ${SECONDARY}, 6, split-movetoworkspacesilent, 6
    bind = ${PRIMARY} ${SECONDARY}, 7, split-movetoworkspacesilent, 7
    bind = ${PRIMARY} ${SECONDARY}, 8, split-movetoworkspacesilent, 8
    bind = ${PRIMARY} ${SECONDARY}, 9, split-movetoworkspacesilent, 9
    bind = ${PRIMARY} ${SECONDARY}, 0, split-movetoworkspacesilent, 10


    # Move through workspaces with mainMod + arrow keys
    bind = ${PRIMARY}, left, split-workspace, e-1
    bind = ${PRIMARY}, right, split-workspace, e+1

    # Scroll through existing workspaces with mainMod + scroll
    bind = ${PRIMARY}, mouse_down, split-workspace, e-1
    bind = ${PRIMARY}, mouse_up, split-workspace, e+1


    # Move active window to other monitor with mainMod + TERTIARY + arrow keys
    bind = ${PRIMARY} ${TERTIARY}, left, split-changemonitor, prev
    bind = ${PRIMARY} ${TERTIARY}, right, split-changemonitor, next
  '';
}
