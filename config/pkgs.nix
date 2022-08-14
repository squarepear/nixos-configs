{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat # Fancy cat
    cacert
    git
    htop # Process monitor
    jq
    killall
    lm_sensors
    neofetch
    neovim
    nixpkgs-fmt
    pciutils
    pfetch
    rsync # Backup utility
    tree
    unzip
    usbutils
    wget

    # Fun
    cmatrix
    sl
    cowsay
  ];

  my.home.packages = with pkgs; lib.mkIf config.system.gui.enable [
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
