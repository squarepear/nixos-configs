{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    btop
    coreutils
    curl
    darwin.lsusb
    direnv
    fastfetch
    ffmpeg
    gnupg
    htop
    neovim
    nil
    nixpkgs-fmt
    pinentry_mac
    platformio-core
    podman
    podman-compose
    starship
    tmux
    tree
    vim
    wget

    # GUI
    audacity
    discord-canary
    google-chrome
    iterm2
    keka
    mos
    prismlauncher
    qemu
    slack
    syncthing
    utm
    vscode
    zoom-us
  ];
}
