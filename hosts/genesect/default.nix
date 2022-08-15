{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../config
    ../../config/distributed-building.nix
    ../../config/docker.nix
    ../../config/nfs.nix
    ../../config/ssh.nix
    ../../config/tailscale.nix
    ../../config/bat.nix
    ../../config/direnv.nix
    ../../config/git.nix
    ../../config/neovim.nix
    ../../config/secrets.nix
    ../../config/vscode.nix
    ../../config/zsh.nix

    ../../users/jeffrey.nix
  ];

  # System hostname
  networking.hostName = "genesect";

  # Boot Settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

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

 programs.fuse.userAllowOther = true;

  fileSystems."/home/${config.user.name}/Developer" =
    {
      device = "jeffrey@kyurem:/Users/jeffrey/Developer";
      fsType = "fuse.sshfs";
      options =
        let
          # this line prevents hanging on network split
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        in
        [ "${automount_opts},comment=sshfs,_netdev,allow_other,uid=1000,gid=100,idmap=user,IdentityFile=/home/jeffrey/.ssh/id_ed25519" ];
    };
}
