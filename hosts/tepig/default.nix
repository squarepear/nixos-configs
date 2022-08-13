{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    "${fetchTarball {
      url = "https://github.com/NixOS/nixos-hardware/archive/3975d5158f00accda15a11180b2c08654cfb2807.tar.gz";
      sha256 = "0z9gpv54ixd5hq3g5hcsyy39d8xzff4lj6p5wsy09g7s4jcm7r99";
    }}/raspberry-pi/4"

    ../../config/system
    ../../config/system/k3s/server.nix
    ../../config/system/backup.nix
    ../../config/system/distributed-building.nix
    ../../config/system/networking.nix
    ../../config/system/nfs.nix
    ../../config/system/ssh.nix
    ../../config/system/tailscale.nix

    ../../config/users/jeffrey.nix
  ];

  # System hostname
  networking.hostName = "tepig";

  # Don't use GUI
  system.gui.enable = false;

  # Networking
  networking.firewall.trustedInterfaces = [ "eth0" "wlan0" ];
}
