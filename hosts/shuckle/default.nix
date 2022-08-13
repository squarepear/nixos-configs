{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../config/system
    ../../config/system/k3s/agent.nix
    ../../config/system/bootloader.nix
    ../../config/system/distributed-building.nix
    ../../config/system/docker.nix
    ../../config/system/glusterfs.nix
    ../../config/system/networking.nix
    ../../config/system/nfs.nix
    ../../config/system/ssh.nix
    ../../config/system/tailscale.nix
    ../../config/system/usb.nix
    ../../config/system/virtualization.nix

    ../../config/users/jeffrey.nix
  ];

  # System hostname
  networking.hostName = "shuckle";

  # Don't use GUI
  system.gui.enable = false;

  # Linux Kernel Version
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Networking
  networking.firewall.trustedInterfaces = [ "enp2s5" "enp4s0" ];
}
