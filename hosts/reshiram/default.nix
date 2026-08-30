{ pkgs, unstable, ... }:

{
  imports = [
    ./config.nix
    ./hardware-configuration.nix
    ./disks.nix
  ];

  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-MSI_M470_1TB_511210708115000680";
  # disko.devices.disk.extra.device = "/dev/disk/by-id/nvme-SKHynix_HFS001TEM4X182N_5ME9N008011209N0Z";

  boot = {
    kernelPackages = unstable.linuxKernel.packages.linux_zen;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "resume_offset=533760" ];
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  networking.hostName = "reshiram";
}
