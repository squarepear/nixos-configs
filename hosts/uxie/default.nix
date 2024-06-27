{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../system
    ../../system/bat.nix
    ../../system/containers.nix
    ../../system/direnv.nix
    ../../system/git.nix
    ../../system/neovim
    ../../system/networking.nix
    ../../system/secrets.nix
    ../../system/ssh.nix
    ../../system/tailscale.nix
    ../../system/virtualization.nix
    ../../system/vscode.nix
    ../../system/zenpower.nix
    ../../system/zsh.nix

    ../../users/jeffrey.nix
  ];

  # System hostname
  networking.hostName = "uxie";

  # Boot Settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # GPU setup
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Automatically trim unused space from the filesystem
  services.fstrim.enable = true;

  # Enable building for aarch64 (Raspberry Pi)
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  pear = {
    desktop.enable = false;

    vendor = {
      cpu = "amd";
      gpu = "amd";
    };
  };
}