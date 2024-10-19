{ config, pkgs, ... }:

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

  # system.activationScripts.applications.text =
  #   let
  #     env = pkgs.buildEnv {
  #       name = "system-applications";
  #       paths = config.environment.systemPackages;
  #       pathsToLink = "/Applications";
  #     };
  #   in
  #   pkgs.lib.mkForce ''
  #     # Set up applications.
  #     echo "setting up /Applications..." >&2
  #     rm -rf /Applications/Nix\ Apps
  #     mkdir -p /Applications/Nix\ Apps
  #     find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
  #     while read src; do
  #       app_name=$(basename "$src")
  #       echo "copying $src" >&2
  #       ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
  #     done
  #   '';
}
