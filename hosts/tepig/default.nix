{ inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4

    ./hardware-configuration.nix

    ../../system/backup.nix
    ../../system/containers.nix
    ../../system/distributed-building.nix
    ../../system/networking.nix
    ../../system/nfs.nix
    ../../system/ssh.nix
    ../../system/tailscale.nix
    ../../system/bat.nix
    ../../system/direnv.nix
    ../../system/git.nix
    ../../system/neovim
    ../../system/secrets.nix
    ../../system/vscode.nix
    ../../system/zsh.nix

    ./home-assistant.nix
    ./monitor.nix
    ./ntfy.nix
    ./reverse-proxy.nix
    ./rssfeed.nix

    ../../users/jeffrey.nix
  ];

  # System hostname
  networking.hostName = "tepig";

  # Disable TPM (not supported on raspberry pi)
  boot.initrd.systemd.tpm2.enable = false;

  # Networking
  networking.firewall.trustedInterfaces = [ "end0" ];
  networking.enableIPv6 = false;

  pear = {
    desktop.enable = false;

    vendor = {
      cpu = "other";
      gpu = "other";
    };
  };
}
