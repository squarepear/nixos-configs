{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}@attrs:

let
  cfg = config.pear.desktop.hyprland;
  helpers = import ./helpers.nix attrs;

  inherit (helpers)
    PRIMARY
    SECONDARY
    TERTIARY
    uwsmExec
    terminal
    editor
    fileManager
    menu
    screenshot
    colorPicker
    date
    ssdir
    ;

  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  workspaces = builtins.concatLists (
    builtins.genList (
      x:
      let
        ws =
          let
            c = (x + 1) / 10;
          in
          builtins.toString (x + 1 - (c * 10));
      in
      [
        "${PRIMARY}, ${ws}, workspace, ${toString (x + 1)}"
        "${PRIMARY} ${SECONDARY}, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
      ]
    ) 10
  );

  splitWorkspaces = builtins.concatLists (
    builtins.genList (
      x:
      let
        ws =
          let
            c = (x + 1) / 10;
          in
          builtins.toString (x + 1 - (c * 10));
      in
      [
        "${PRIMARY}, ${ws}, split-workspace, ${toString (x + 1)}"
        "${PRIMARY} ${SECONDARY}, ${ws}, split-movetoworkspacesilent, ${toString (x + 1)}"
      ]
    ) 10
  );
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      wayland.windowManager.hyprland.settings = {
        # mouse movements
        bindm = [
          "${PRIMARY}, mouse:272, movewindow"
          "${PRIMARY}, mouse:273, resizewindow"
        ];

        # binds
        bind = [
          # compositor commands
          "${PRIMARY}, M, exec, pkill Hyprland"
          "${PRIMARY}, Q, killactive,"
          "${PRIMARY}, F, fullscreen,"
          "${PRIMARY} ${SECONDARY}, space, togglefloating,"
          "${PRIMARY}, P, pseudo,"
          "${PRIMARY}, R, forcerendererreload,"

          # utility
          # terminal
          "${PRIMARY}, return, exec, ${uwsmExec terminal}"
          # popup terminal
          "${PRIMARY} ${SECONDARY}, return, exec, ${uwsmExec terminal} --class popup-terminal"
          # file manager
          "${PRIMARY} ${SECONDARY}, F, exec, ${uwsmExec fileManager}"
          # editor
          "${PRIMARY}, C, exec, ${uwsmExec editor}"
          # launcher
          "${PRIMARY}, space, exec, ${menu}"
          ", XF86Search, exec, ${menu}"
          # lock screen
          "${PRIMARY}, L, exec, ${lib.getExe pkgs.hyprlock} --immediate"
          "${PRIMARY} ${SECONDARY}, L, exec, systemctl suspend"
          # color picker
          "${PRIMARY} ${SECONDARY}, C, exec, ${colorPicker} -a"

          # move focus
          "${PRIMARY} ${SECONDARY}, left, movefocus, l"
          "${PRIMARY} ${SECONDARY}, right, movefocus, r"
          "${PRIMARY} ${SECONDARY}, up, movefocus, u"
          "${PRIMARY} ${SECONDARY}, down, movefocus, d"

          # screenshots
          "${PRIMARY}, s, exec, ${screenshot} save screen \"${ssdir}/$(${date} +\"%Y-%m-%d %H:%M:%S\").png\""
          "${PRIMARY} ${SECONDARY}, s, exec, ${screenshot} save active \"${ssdir}/$(${date} +\"%Y-%m-%d %H:%M:%S\").png\""
          "${PRIMARY} ${TERTIARY}, s, exec, ${screenshot} save area \"${ssdir}/$(${date} +\"%Y-%m-%d %H:%M:%S\").png\""
        ]
        ++ (
          if cfg.enableSplitMonitorWorkspaces then
            splitWorkspaces
            ++ [
              "${PRIMARY}, left, split-workspace, e-1"
              "${PRIMARY}, right, split-workspace, e+1"
              "${PRIMARY}, mouse_down, split-workspace, e-1"
              "${PRIMARY}, mouse_up, split-workspace, e+1"
              "${PRIMARY} ${TERTIARY}, left, split-changemonitor, prev"
              "${PRIMARY} ${TERTIARY}, right, split-changemonitor, next"
            ]
          else
            workspaces
            ++ [
              "${PRIMARY}, left, workspace, e-1"
              "${PRIMARY}, right, workspace, e+1"
              "${PRIMARY}, mouse_down, workspace, e-1"
              "${PRIMARY}, mouse_up, workspace, e+1"
            ]
        );

        bindl = [
          # media controls
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          # audio
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];

        bindle = [ ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" ];

        binde = [ ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+" ];
      };
    });
  };
}
