{ pkgs, ... }:

{
  imports = [
    ./config.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "altaria";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      configurationLimit = 1;
    };
  };

  # QEMU guest agent for hypervisor integration
  services.qemuGuest.enable = true;

  # Minecraft server — requires nix-minecraft flake input (not yet in flake.nix)
  # imports = [ ./minecraft-server.nix ];
}
