{
  config,
  lib,
  pearlib,
  pkgs,
  unstable,
  ...
}@attrs:

let
  cfg = config.pear.desktop.hyprland;
  helpers = import ./helpers.nix attrs;

  inherit (helpers)
    PRIMARY
    SECONDARY
    TERTIARY
    terminal
    editor
    fileManager
    menu
    screenshot
    colorPicker
    date
    ssdir
    ;

  mkLua = lib.generators.mkLuaInline;
  toLua = lib.generators.toLua { };

  # hl.bind entry from keys + dispatcher + opts (always passed; an empty table is fine).
  bind = keys: dispatcher: opts: {
    _args = [
      keys
      (mkLua dispatcher)
      opts
    ];
  };

  # Shorthand for `hl.dsp.exec_cmd("...")`.
  dspExec = cmd: "hl.dsp.exec_cmd(${toLua cmd})";

  # Plugin dispatcher reference wrapped in a function so the lookup happens
  # at bind-fire time, after the package has been required (in conf/settings.nix).
  smw = expr: "function() return smw.${expr}() end";

  # Generate workspace 1-10 binds for either the built-in or split-monitor dispatcher.
  wsBinds =
    switch: move:
    builtins.concatLists (
      builtins.genList (
        x:
        let
          i = x + 1;
          key = if i == 10 then "0" else toString i;
        in
        [
          (bind "${PRIMARY} + ${key}" (switch i) { })
          (bind "${PRIMARY} + ${SECONDARY} + ${key}" (move i) { })
        ]
      ) 10
    );

  builtinWsBinds = wsBinds (i: ''hl.dsp.workspace("${toString i}")'') (
    i: "hl.dsp.window.move({ workspace = ${toString i}, follow = false })"
  );

  smwWsBinds = wsBinds (i: smw "workspace(\"${toString i}\")") (
    i: smw "move_to_workspace_silent(\"${toString i}\")"
  );

  bindList = [
    # compositor commands
    (bind "${PRIMARY} + M" (dspExec "pkill Hyprland") { })
    (bind "${PRIMARY} + Q" "hl.dsp.window.kill()" { })
    (bind "${PRIMARY} + F" "hl.dsp.window.fullscreen()" { })
    (bind "${PRIMARY} + ${SECONDARY} + space" ''hl.dsp.window.float({ action = "toggle" })'' { })
    (bind "${PRIMARY} + P" "hl.dsp.window.pseudo()" { })
    (bind "${PRIMARY} + R" "hl.dsp.force_renderer_reload()" { })

    # utility
    (bind "${PRIMARY} + return" (dspExec terminal) { })
    (bind "${PRIMARY} + ${SECONDARY} + return" (dspExec "${terminal} --class popup-terminal") { })
    (bind "${PRIMARY} + ${SECONDARY} + F" (dspExec fileManager) { })
    (bind "${PRIMARY} + C" (dspExec editor) { })
    (bind "${PRIMARY} + space" (dspExec menu) { })
    (bind "XF86Search" (dspExec menu) { })
    (bind "${PRIMARY} + L" (dspExec "${lib.getExe pkgs.hyprlock} --immediate") { })
    (bind "${PRIMARY} + ${SECONDARY} + L" (dspExec "systemctl suspend") { })
    (bind "${PRIMARY} + ${SECONDARY} + C" (dspExec "${colorPicker} -a") { })

    # move focus
    (bind "${PRIMARY} + ${SECONDARY} + left" ''hl.dsp.focus({ direction = "l" })'' { })
    (bind "${PRIMARY} + ${SECONDARY} + right" ''hl.dsp.focus({ direction = "r" })'' { })
    (bind "${PRIMARY} + ${SECONDARY} + up" ''hl.dsp.focus({ direction = "u" })'' { })
    (bind "${PRIMARY} + ${SECONDARY} + down" ''hl.dsp.focus({ direction = "d" })'' { })

    # screenshots
    (bind "${PRIMARY} + s"
      (dspExec "${screenshot} save screen \"${ssdir}/$(${date} +\"%Y-%m-%d %H:%M:%S\").png\"")
      { }
    )
    (bind "${PRIMARY} + ${SECONDARY} + s"
      (dspExec "${screenshot} save active \"${ssdir}/$(${date} +\"%Y-%m-%d %H:%M:%S\").png\"")
      { }
    )
    (bind "${PRIMARY} + ${TERTIARY} + s"
      (dspExec "${screenshot} save area \"${ssdir}/$(${date} +\"%Y-%m-%d %H:%M:%S\").png\"")
      { }
    )
  ]
  ++ (
    if cfg.enableSplitMonitorWorkspaces then
      smwWsBinds
      ++ [
        (bind "${PRIMARY} + left" (smw "cycle_workspaces(\"prev\")") { })
        (bind "${PRIMARY} + right" (smw "cycle_workspaces(\"next\")") { })
        (bind "${PRIMARY} + mouse_down" (smw "cycle_workspaces(\"prev\")") { mouse = true; })
        (bind "${PRIMARY} + mouse_up" (smw "cycle_workspaces(\"next\")") { mouse = true; })
        (bind "${PRIMARY} + ${TERTIARY} + left" (smw "change_monitor(\"prev\")") { })
        (bind "${PRIMARY} + ${TERTIARY} + right" (smw "change_monitor(\"next\")") { })
      ]
    else
      builtinWsBinds
      ++ [
        (bind "${PRIMARY} + left" ''hl.dsp.workspace("-1")'' { })
        (bind "${PRIMARY} + right" ''hl.dsp.workspace("+1")'' { })
        (bind "${PRIMARY} + mouse_down" ''hl.dsp.workspace("-1")'' { mouse = true; })
        (bind "${PRIMARY} + mouse_up" ''hl.dsp.workspace("+1")'' { mouse = true; })
      ]
  );

  bindlList = [
    (bind "XF86AudioPlay" (dspExec "playerctl play-pause") { locked = true; })
    (bind "XF86AudioNext" (dspExec "playerctl next") { locked = true; })
    (bind "XF86AudioPrev" (dspExec "playerctl previous") { locked = true; })
    (bind "XF86AudioMute" (dspExec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") { locked = true; })
  ];

  bindleList = [
    (bind "XF86AudioLowerVolume" (dspExec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") {
      locked = true;
      repeating = true;
    })
  ];

  bindeList = [
    (bind "XF86AudioRaiseVolume" (dspExec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+") {
      locked = true;
      repeating = true;
    })
  ];

  bindmList = [
    (bind "${PRIMARY} + mouse:272" "hl.dsp.window.drag()" { mouse = true; })
    (bind "${PRIMARY} + mouse:273" "hl.dsp.window.resize()" { mouse = true; })
  ];
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      wayland.windowManager.hyprland.settings = {
        bind = bindList ++ bindlList ++ bindleList ++ bindeList ++ bindmList;
      };
    });
  };
}
