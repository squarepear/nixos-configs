{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.nixos-hardware.nixosModules.gigabyte-b550

    ./config.nix
    ./hardware-configuration.nix
    ./disks.nix
  ];

  networking.hostName = "uxie";

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
  };

  # Periodically trim unused space from the filesystem
  services.fstrim.enable = true;

  # Monitor disk health
  services.smartd.enable = true;

  # Allow building aarch64 (Raspberry Pi) packages via QEMU
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Kiosk display: runs Chromium in a locked-down Wayland cage session
  users.extraUsers.kiosk.isNormalUser = true;
  services.cage = {
    enable = true;
    user = "kiosk";
    program = "${pkgs.ungoogled-chromium}/bin/chromium --password-store=basic --incognito --disable-infobars --kiosk https://nas.hl.pear.cx/public/display/index.html";
    extraArguments = [
      "-d"
      "-D"
      "-s"
    ];
    environment.WLR_LIBINPUT_NO_DEVICES = "1";
  };
  systemd.services."cage-tty1".restartIfChanged = lib.mkForce true;
}
