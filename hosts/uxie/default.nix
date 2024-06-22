{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../config
    ../../config/bat.nix
    ../../config/containers.nix
    ../../config/direnv.nix
    ../../config/git.nix
    ../../config/neovim
    ../../config/networking.nix
    ../../config/secrets.nix
    ../../config/ssh.nix
    ../../config/tailscale.nix
    ../../config/virtualization.nix
    ../../config/vscode.nix
    ../../config/zenpower.nix
    ../../config/zsh.nix

    ../../users/jeffrey.nix
  ];

  # System hostname
  networking.hostName = "uxie";

  # Boot Settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Use GUI (hyprland)
  system.gui.enable = false;


  # GPU setup
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Automatically trim unused space from the filesystem
  services.fstrim.enable = true;

  # Enable building for aarch64 (Raspberry Pi)
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];
}
