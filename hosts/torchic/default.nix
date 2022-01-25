{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../config/system
    ../../config/system/k3s/agent.nix
    ../../config/system/backup.nix
    ../../config/system/docker.nix
    ../../config/system/glusterfs.nix
    ../../config/system/networking.nix
    ../../config/system/ssh.nix
    ../../config/system/tailscale.nix
    ../../config/system/usb.nix

    ../../config/users/jeffrey.nix
  ];

  # System hostname
  system.name = "torchic";

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
