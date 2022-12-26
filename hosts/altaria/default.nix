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
    ../../config/neovim.nix
    ../../config/secrets.nix
    ../../config/vscode.nix
    ../../config/zsh.nix

    ./minecraft-server.nix

    ../../users/jeffrey.nix
  ];

  # System hostname
  networking.hostName = "altaria";

  # Boot Settings
  boot = {
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Don't GUI (sway)
  system.gui.enable = false;

  # Qemu guest settings
  services.qemuGuest.enable = true;

  # extra settings
  boot.cleanTmpDir = true;
  zramSwap.enable = true;
}
