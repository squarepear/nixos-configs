{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../config/system
    ../../config/system/k3s/manager.nix
    ../../config/system/audio.nix
    ../../config/system/backup.nix
    ../../config/system/bluetooth.nix
    ../../config/system/bootloader.nix
    ../../config/system/docker.nix
    ../../config/system/gaming.nix
    ../../config/system/gui.nix
    ../../config/system/networking.nix
    ../../config/system/printing.nix
    ../../config/system/rgb.nix
    ../../config/system/ssd.nix
    ../../config/system/ssh.nix
    ../../config/system/tailscale.nix
    ../../config/system/usb.nix
    ../../config/system/virtualization.nix
    ../../config/system/zenpower.nix

    ../../config/users/jeffrey.nix
  ];

  # System hostname
  system.name = "reshiram";

  # Use GUI (sway)
  system.gui.enable = true;

  # Linux Kernel Version
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # GPU setup
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Networking
  networking.firewall.trustedInterfaces = [ "eno1" "wlp5s0" ];
}
