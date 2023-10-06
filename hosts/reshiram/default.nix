{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../config
    ../../config/audio.nix
    ../../config/backup.nix
    ../../config/bat.nix
    ../../config/bluetooth.nix
    ../../config/cad.nix
    ../../config/containers.nix
    ../../config/direnv.nix
    ../../config/firefox.nix
    ../../config/fonts.nix
    ../../config/gamedev.nix
    ../../config/gaming.nix
    ../../config/git.nix
    ../../config/keyboard.nix
    ../../config/hyprland
    ../../config/k3s/manager.nix
    ../../config/kitty.nix
    ../../config/music.nix
    ../../config/neovim
    ../../config/networking.nix
    ../../config/nfs.nix
    ../../config/obs.nix
    ../../config/printing.nix
    ../../config/rgb.nix
    ../../config/secrets.nix
    ../../config/ssh.nix
    ../../config/tailscale.nix
    ../../config/usb.nix
    ../../config/virtualization.nix
    ../../config/vscode.nix
    ../../config/waydroid.nix
    ../../config/zenpower.nix
    ../../config/zsh.nix

    ../../users/jeffrey.nix
  ];

  # System hostname
  networking.hostName = "reshiram";

  # Boot Settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Use GUI (sway)
  system.gui.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [ liquidctl ];

  # GPU setup
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Networking
  networking.firewall.trustedInterfaces = [
    "eno1"
    # "wlp5s0"
  ];

  # Windows dualboot settings
  time.hardwareClockInLocalTime = true;

  # Automatically trim unused space from the filesystem
  services.fstrim.enable = true;

  # Enable building for aarch64 (Raspberry Pi)
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];
}
