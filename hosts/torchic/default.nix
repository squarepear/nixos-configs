{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../config
    ../../config/backup.nix
    ../../config/distributed-building.nix
    ../../config/docker.nix
    ../../config/docker.nix
    ../../config/networking.nix
    ../../config/nfs.nix
    ../../config/ssh.nix
    ../../config/tailscale.nix
    ../../config/usb.nix
    ../../config/bat.nix
    ../../config/direnv.nix
    ../../config/git.nix
    ../../config/neovim.nix
    ../../config/secrets.nix
    ../../config/zsh.nix

    ../../users/jeffrey.nix
  ];

  # System hostname
  networking.hostName = "torchic";

  # Don't use GUI
  system.gui.enable = false;

  # Boot config
  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware.enableRedistributableFirmware = true;

  # Networking
  networking.firewall.trustedInterfaces = [ "eth0" "wlan0" ];
}
