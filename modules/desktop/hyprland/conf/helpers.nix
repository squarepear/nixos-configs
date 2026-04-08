{
  lib,
  pkgs,
  unstable,
  ...
}:

{
  PRIMARY = "SUPER";
  SECONDARY = "SHIFT";
  TERTIARY = "ALT";

  uwsmExec = cmd: "uwsm app -- ${cmd}";

  terminal = lib.getExe unstable.kitty;
  editor = lib.getExe unstable.vscode;
  fileManager = lib.getExe pkgs.nemo;
  menu = "${unstable.tofi}/bin/tofi-drun | xargs ${"uwsm app -- "}";
  screenshot = lib.getExe unstable.grimblast;
  colorPicker = lib.getExe unstable.hyprpicker;
  date = "${pkgs.coreutils}/bin/date";
  ssdir = "$HOME/Pictures/Screenshots";

  cursor = "Bibata-Modern-Classic-hyprcursor";
  cursorSize = 24;
}
