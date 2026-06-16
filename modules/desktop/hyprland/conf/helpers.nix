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

  terminal = lib.getExe unstable.kitty;
  editor = lib.getExe unstable.vscode;
  fileManager = lib.getExe pkgs.nemo;
  menu = "${unstable.tofi}/bin/tofi-drun | xargs ${lib.getExe pkgs.glib}/bin/gio launch";
  screenshot = lib.getExe unstable.grimblast;
  colorPicker = lib.getExe unstable.hyprpicker;
  date = "${pkgs.coreutils}/bin/date";
  ssdir = "$HOME/Pictures/Screenshots";

  cursor = "Bibata-Modern-Classic-hyprcursor";
  cursorSize = 24;
}
