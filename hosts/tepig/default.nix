{ config, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4

    ./config.nix
    ./hardware-configuration.nix
    ./disks.nix
  ];

  networking.hostName = "tepig";

  # Raspberry Pi 4 has no TPM
  boot.initrd.systemd.tpm2.enable = false;

  # Trust the wired ethernet interface (no firewalling on local LAN)
  networking.firewall.trustedInterfaces = [ "end0" ];
  networking.enableIPv6 = false;
}
