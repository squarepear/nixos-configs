{ pkgs, lib, ... }:

rec {
  # Key modifiers
  PRIMARY = "SUPER";
  SECONDARY = "SHIFT";
  TERTIARY = "ALT";

  # Common applications
  terminal = lib.getExe pkgs.kitty;
  editor = lib.getExe pkgs.vscode;
  fileManager = lib.getExe pkgs.nemo;
  menu = "${pkgs.tofi}/bin/tofi-drun | xargs ${uwsmExec ""}";
  screenshot = lib.getExe pkgs.grimblast;
  colorPicker = lib.getExe pkgs.hyprpicker;
  date = "${pkgs.coreutils}/bin/date";

  # Helper functions
  uwsmExec = cmd: "uwsm app -- ${cmd}";
  notifExec = notif: cmd: "notify-send ${notif}; ${cmd}";

  # Variables
  primaryMonitor = "DP-2";
}
