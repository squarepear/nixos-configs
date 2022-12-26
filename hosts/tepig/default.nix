{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    "${fetchTarball {
      url = "https://github.com/NixOS/nixos-hardware/archive/c9c1a5294e4ec378882351af1a3462862c61cb96.tar.gz";
      sha256 = "166dqx7xgrn0906y5yz5a5l66q52wql1nh6086y4pli7s69wvf1s";
    }}/raspberry-pi/4"

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
    ../../config/neovim.nix
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
