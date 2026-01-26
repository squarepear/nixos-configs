{
  inputs,
  lib,
  pkgs,
  ...
}:

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

    ./copyparty.nix
    ./immich.nix
    ./jellyfin.nix
    ./n8n.nix
    ./open-webui.nix
    ./reverse-proxy.nix

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

  services.smartd.enable = true;

  # Enable building for aarch64 (Raspberry Pi)
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  users.extraUsers.kiosk.isNormalUser = true;
  services.cage = {
    enable = true;
    user = "kiosk";
    program = "${pkgs.ungoogled-chromium}/bin/chromium --password-store=basic --incognito --disable-infobars --kiosk https://nas.hl.pear.cx/public/display/index.html";
    #program = "${pkgs.mesa-demos}/bin/glxgears";
    extraArguments = [
      "-d"
      "-D"
      "-s"
    ];
    environment = {
      WLR_LIBINPUT_NO_DEVICES = "1";
    };
  };
  systemd.services."cage-tty1".restartIfChanged = lib.mkForce true;

  pear = {
    desktop.enable = false;

    vendor = {
      cpu = "amd";
      gpu = "amd";
    };
  };
}
