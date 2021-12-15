{ pkgs, ... }:

{
  # Packages installed in system profile.
  environment.systemPackages = with pkgs; [
    bat # Fancy cat
    cacert
    kubectl
    kubernetes-helm
    git
    htop # Process monitor
    jq
    killall
    lm_sensors
    neofetch
    neovim
    pciutils
    pfetch
    rsync # Backup utility
    tree
    unzip
    usbutils
    wget
  ];
}
