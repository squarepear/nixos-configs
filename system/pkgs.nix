{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat # Fancy cat
    cacert
    git
    htop # Process monitor
    btop # Process monitor
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
    tmux
    iperf3

    # Fun
    cmatrix
    sl
    cowsay
  ];

  my.home.packages = with pkgs; lib.mkIf config.pear.desktop.enable [
    discord-canary
    feh
    # libreoffice
    lxmenu-data
    xarchiver
    mpv
    shared-mime-info
    slack
    betterbird
  ];
}
