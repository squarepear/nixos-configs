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

  disko.devices.disk.main.device = "/dev/disk/by-id/ata-KINGSTON_SV300S37A120G_50026B773B0342AF";
  disko.devices.disk.extra.device = "/dev/disk/by-id/nvme-Samsung_SSD_980_500GB_S64ENG0R305552V";

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
  users.extraUsers.kiosk = {
    isNormalUser = true;
    # video group grants direct DRM access, required when the logind session
    # scope is not yet active at the time cage initialises its seat.
    extraGroups = [ "video" ];
  };
  services.cage = {
    enable = true;
    user = "kiosk";
    program = "${pkgs.ungoogled-chromium}/bin/chromium --password-store=basic --incognito --disable-infobars --kiosk https://nas.hl.pear.cx/public/display/index.html";
    extraArguments = [
      "-d"
      "-D"
      "-s"
    ];
    environment = {
      WLR_LIBINPUT_NO_DEVICES = "1";
      # Use libseat's direct backend so cage can open the DRM device without
      # a fully-activated logind session scope. Avoids a systemd race where
      # pam_systemd.so registers the session asynchronously and cage's
      # wlroots backend attempts TakeDevice before the scope is live.
      LIBSEAT_BACKEND = "direct";
    };
  };
  systemd.services."cage-tty1".restartIfChanged = lib.mkForce true;
}
