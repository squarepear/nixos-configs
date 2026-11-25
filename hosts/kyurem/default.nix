{ inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.apple-t2

    ./config.nix
    ./hardware-configuration.nix
    ./disks.nix
  ];

  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-APPLE_SSD_AP0512N_C029475004XNGY318";

  hardware.apple-t2 = {
    kernelChannel = "latest";
    firmware.enable = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "resume_offset=533760" ];
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  networking.hostName = "kyurem";
}
