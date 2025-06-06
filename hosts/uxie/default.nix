{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.gigabyte-b550

    ./hardware-configuration.nix

    ../../system/backup.nix
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

    ./immich.nix
    ./jellyfin.nix
    ./open-webui.nix

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

  # SMB
  services.samba = {
    enable = true;

    settings = {
      media = {
        path = "/mnt/main-pool/media";
        "valid users" = "jeffrey";
        public = false;
        writable = true;
      };

      time-machine = {
        path = "/mnt/main-pool/backups/macOS";
        "valid users" = "jeffrey";
        public = false;
        writeable = true;
        "force user" = "jeffrey";
        "fruit:aapl" = true;
        "fruit:time machine" = true;
        "vfs objects" = "catia fruit streams_xattr";
      };

      homes = {
        path = "/mnt/main-pool/users-share/%S";
        "valid users" = "%S";
        "create mask" = "0700";
        "directory mask" = "0700";
        browseable = false;
        public = false;
        writeable = true;
      };
    };
  };
}
