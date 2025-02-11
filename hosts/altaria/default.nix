{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../system/backup.nix
    ../../system/containers.nix
    ../../system/distributed-building.nix
    ../../system/nfs.nix
    ../../system/ssh.nix
    ../../system/tailscale.nix
    ../../system/bat.nix
    ../../system/direnv.nix
    ../../system/git.nix
    ../../system/neovim
    ../../system/secrets.nix
    ../../system/vscode.nix
    ../../system/zsh.nix

    # ./minecraft-server.nix

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
      configurationLimit = 1;
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Qemu guest settings
  services.qemuGuest.enable = true;

  pear = {
    desktop.enable = false;

    vendor = {
      cpu = "other";
      gpu = "other";
    };
  };
}
