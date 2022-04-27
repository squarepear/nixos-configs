{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; lib.mkIf config.system.gui.enable [
    discord-canary
    feh
    libreoffice
    lxmenu-data
    mpv
    pcmanfm
    shared-mime-info
    slack
    zoom-us
  ];
}
