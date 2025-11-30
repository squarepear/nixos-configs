{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.desktop.hyprland;

  shellDir = ./shell;

  cmd = pkgs.writeShellScriptBin "pearshell" ''
    ${lib.getExe pkgs.quickshell} -n -p ${shellDir}/shell.qml
  '';
in
{
  config = lib.mkIf (cfg.enable && cfg.enableQuickshell) {
    home-manager.users = pearlib.perUser (_: {
      home.packages = with pkgs; [
        quickshell
        cmd
      ];
      # wayland.windowManager.hyprland.settings = {
      #   bind = [
      #     "${PRIMARY}, TAB, exec, ${quickshellCmd}"
      #   ];
      # };
    });
  };
}
