{
  config,
  lib,
  pkgs,
  ...
}:

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
    fastfetch
    neovim
    nixfmt
    nixfmt-tree
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

  my.home.packages =
    with pkgs;
    lib.mkIf config.pear.desktop.enable [
      feh
      # libreoffice
      lxmenu-data
      xarchiver
      mpv
      shared-mime-info
      discord-canary
      slack
      zathura
      # betterbird
    ];
}
