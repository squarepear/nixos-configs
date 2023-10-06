{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.system.gui.wm == "hyprland") {
    my.home.packages = with pkgs; [
      # qt wayland
      libsForQt5.qt5.qtwayland
      qt6.qtwayland

      # file manager
      cinnamon.nemo-with-extensions

      # runner
      wofi

      # wallpaper
      swaybg

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
