{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./config.nix
    ./hardware-configuration.nix
    ./disks.nix
  ];

  # disko.devices.disk.main.device = "/dev/nvme0n1";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # TODO: Replace with actual offset: https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
    # kernelParams = [ "resume_offset=533760" ];
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  networking.hostName = "reshiram"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "America/Indianapolis";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.11";
}
