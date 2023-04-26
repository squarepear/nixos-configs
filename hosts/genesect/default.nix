{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../config
    ../../config/containers.nix
    ../../config/distributed-building.nix
    ../../config/nfs.nix
    ../../config/ssh.nix
    ../../config/tailscale.nix
    ../../config/bat.nix
    ../../config/direnv.nix
    ../../config/git.nix
    ../../config/neovim
    ../../config/secrets.nix
    ../../config/vscode.nix
    ../../config/zsh.nix

    ../../users/jeffrey.nix
  ];

  # System hostname
  networking.hostName = "genesect";

  # Boot Settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Don't GUI (sway)
  system.gui.enable = false;

  # Qemu guest settings
  services.qemuGuest.enable = true;

  # Networking
  networking.firewall.trustedInterfaces = [ "enp0s3" ];

  # ssh to host machine
  programs.ssh.extraConfig = ''
    Host kyurem
      HostName 10.0.2.2
  '';
}
