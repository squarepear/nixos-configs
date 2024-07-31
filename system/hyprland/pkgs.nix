{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.pear.desktop.wm == "hyprland") {
    my.home.packages = with pkgs; [
      # qt wayland
      libsForQt5.qt5.qtwayland
      qt6.qtwayland

      # file manager
      nemo-with-extensions

      # runner
      wofi

      # screenshots
      sway-contrib.grimshot
      grim

      # random
      libnotify
      xdg-utils
      wl-clipboard
      playerctl
      whitesur-gtk-theme
      numix-icon-theme-circle
    ];
  };
}
