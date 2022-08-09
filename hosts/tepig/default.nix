{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    "${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/2a7063461c3751d83869a2a0a8ebc59e34bec5b2.tar.gz" }/raspberry-pi/4"

    ../../config/system
    ../../config/system/k3s/server.nix
    ../../config/system/backup.nix
    ../../config/system/docker.nix
    ../../config/system/glusterfs.nix
    ../../config/system/networking.nix
    ../../config/system/nfs.nix
    ../../config/system/ssh.nix
    ../../config/system/tailscale.nix
    ../../config/system/usb.nix

    ../../config/users/jeffrey.nix
  ];

  # System hostname
  system.name = "tepig";

  # Don't use GUI
  system.gui.enable = false;

  # Enable Minecraft Server
  environment.systemPackages = with pkgs; [
    jdk17
  ];

  systemd.services.minecraft-server = {
    description = "Run the HFGS Minecraft server";

    wants = [ "network.target" ];
    after = [ "network.target" ];

    unitConfig = {
      Type = "simple";
      RequiresMountsFor = "/cluster-nfs";
    };

    serviceConfig = {
      WorkingDirectory = "/cluster-nfs/minecraft/survival-hfgs/";
      ExecStart = "${pkgs.jdk17}/bin/java -Xmx4G --add-modules jdk.incubator.vector -jar fabric-server-mc.1.18.1-loader.0.12.12-launcher.0.10.2.jar nogui";
    };

    wantedBy = [ "multi-user.target" ];
  };

  # Enable NFS Server
  services.nfs.server = {
    enable = true;

    exports = ''
      /cluster-nfs 100.0.0.0/8(rw,sync,no_root_squash,insecure)
    '';
  };
  networking.firewall.allowedTCPPorts = [ 2049 ];

  # Networking
  networking.firewall.trustedInterfaces = [ "eth0" "wlan0" ];
}
