{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat # Fancy cat
    cacert
    git
    htop # Process monitor
    jq
    killall
    kubectl
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
  ];
}
