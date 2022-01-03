{ pkgs, ... }:

{
  imports = [
    ../../config/system
    ../../config/system/bootloader.nix
    ../../config/system/docker.nix
    ../../config/system/networking.nix
    ../../config/system/ssh.nix
    ../../config/system/tailscale.nix
    ../../config/system/usb.nix
    ../../config/system/virtualization.nix

    ../../config/users/jeffrey.nix

    ../../config/home
  ];

  home-manager.users.jeffrey = { ... }: {
    imports = [
      ../../config/home/bat.nix
      ../../config/home/direnv.nix
      ../../config/home/git.nix
      ../../config/home/neovim.nix
      ../../config/home/secrets.nix
      ../../config/home/zsh.nix
    ];
  };

  # System hostname
  system.name = "shuckle";

  # Don't use GUI
  system.gui.enable = false;

  # Linux Kernel Version
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Networking
  networking.firewall.trustedInterfaces = [ "enp2s5" "enp4s0" ];
}
