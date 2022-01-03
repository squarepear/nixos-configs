# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/333b1c2c-db0d-4d01-bb48-06d70d3b69a9";
      fsType = "btrfs";
      options = [ "subvol=@" "autodefrag" "noatime" ];
    };

  fileSystems."/games" =
    {
      device = "/dev/disk/by-uuid/333b1c2c-db0d-4d01-bb48-06d70d3b69a9";
      fsType = "btrfs";
      options = [ "subvol=@games" "autodefrag" "noatime" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/333b1c2c-db0d-4d01-bb48-06d70d3b69a9";
      fsType = "btrfs";
      options = [ "subvol=@home" "autodefrag" "noatime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/E61A-6632";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/2adf0dd9-0942-4b49-9a18-b4d5f273926b"; }];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
