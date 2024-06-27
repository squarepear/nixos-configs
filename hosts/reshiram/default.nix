{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../system
    ../../system/ai.nix
    ../../system/audio.nix
    ../../system/backup.nix
    ../../system/bat.nix
    ../../system/bluetooth.nix
    ../../system/cad.nix
    ../../system/containers.nix
    ../../system/direnv.nix
    ../../system/firefox.nix
    ../../system/fonts.nix
    ../../system/gamedev.nix
    ../../system/gaming.nix
    ../../system/git.nix
    ../../system/keyboard.nix
    ../../system/hyprland
    ../../system/k3s/manager.nix
    ../../system/kitty.nix
    ../../system/music.nix
    ../../system/neovim
    ../../system/networking.nix
    ../../system/nfs.nix
    ../../system/obs.nix
    ../../system/printing.nix
    ../../system/rgb.nix
    ../../system/secrets.nix
    ../../system/ssh.nix
    ../../system/tailscale.nix
    ../../system/usb.nix
    ../../system/virtualization.nix
    ../../system/vscode.nix
    # ../../system/waydroid.nix
    ../../system/zenpower.nix
    ../../system/zsh.nix

    ../../users/jeffrey.nix
  ];

  # System hostname
  networking.hostName = "reshiram";

  # Boot Settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Packages
  environment.systemPackages = with pkgs; [ liquidctl ];

  # Automatically trim unused space from the filesystem
  services.fstrim.enable = true;

  # Enable building for aarch64 (Raspberry Pi)
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  pear = {
    desktop = {
      enable = true;
      wm = "hyprland";
    };

    vendor = {
      cpu = "amd";
      gpu = "amd";
    };
  };
}
