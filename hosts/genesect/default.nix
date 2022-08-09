{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../config/system
    ../../config/system/bootloader.nix
    ../../config/system/docker.nix
    ../../config/system/ssh.nix
    ../../config/system/tailscale.nix

    ../../config/users/jeffrey.nix
  ];

  # System hostname
  system.name = "genesect";
  networking.hostName = config.system.name;

  # Don't GUI (sway)
  system.gui.enable = false;

  # Qemu guest settings
  services.qemuGuest.enable = true;

  # Networking
  networking.firewall.trustedInterfaces = [ "enp0s3" ];

  # Filesystems
  environment.systemPackages = with pkgs; [
    fuse
    sshfs
  ];

  fileSystems."/home/jeffrey/Developer" =
    { device = "jeffrey@kyurem:/Users/jeffrey/Developer";
      fsType = "fuse.sshfs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        in [ "${automount_opts},comment=sshfs,_netdev,allow_other,uid=1000,gid=100,idmap=user,IdentityFile=/home/jeffrey/.ssh/id_ed25519" ];
    };
}
