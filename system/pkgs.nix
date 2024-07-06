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
    pfetch-rs
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
    pokedex
  ];

  my.home.packages = with pkgs; lib.mkIf config.pear.desktop.enable [
    feh
    # libreoffice
    lxmenu-data
    xarchiver
    mpv
    shared-mime-info
    slack
    betterbird
  ];

  my.xdg.desktopEntries = lib.mkIf config.pear.desktop.enable {
    discord = {
      name = "Discord";
      genericName = "discord";
      exec = "${lib.getExe pkgs.vesktop}";
      terminal = false;
      categories = [ "Application" "Chat" ];
    };
  };
}
