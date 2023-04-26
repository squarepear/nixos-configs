{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../config
    # ../../config/k3s/server.nix
    ../../config/backup.nix
    ../../config/containers.nix
    ../../config/distributed-building.nix
    ../../config/networking.nix
    ../../config/nfs.nix
    ../../config/ssh.nix
    ../../config/tailscale.nix
    ../../config/bat.nix
    ../../config/direnv.nix
    ../../config/git.nix
    ../../config/neovim
    ../../config/secrets.nix
    ../../config/vscode.nix
    ../../config/zsh.nix

    ../../users/jeffrey.nix
  ];

  # System hostname
  networking.hostName = "tepig";

  # Don't use GUI
  system.gui.enable = false;

  # Networking
  networking.firewall.trustedInterfaces = [ "end0" ];
  networking.enableIPv6 = false;
}
