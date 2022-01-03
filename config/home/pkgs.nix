{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; lib.mkIf config.system.gui.enable [
    discord-canary
    feh
    libreoffice
    lxmenu-data
    mpv
    pcmanfm
    psensor
    shared_mime_info
    slack
    zoom-us
  ];
}
