{
  lib,
  pkgs,
  ...
}:

{
  PRIMARY = "SUPER";
  SECONDARY = "SHIFT";
  TERTIARY = "ALT";

  uwsmExec = cmd: "uwsm app -- ${cmd}";

  terminal = lib.getExe pkgs.kitty;
  editor = lib.getExe pkgs.vscode;
  fileManager = lib.getExe pkgs.nemo;
  menu = "${pkgs.tofi}/bin/tofi-drun | xargs ${"uwsm app -- "}";
  screenshot = lib.getExe pkgs.grimblast;
  colorPicker = lib.getExe pkgs.hyprpicker;
  date = "${pkgs.coreutils}/bin/date";
  ssdir = "$HOME/Pictures/Screenshots";

  cursor = "Bibata-Modern-Classic-hyprcursor";
  cursorSize = 24;
}
