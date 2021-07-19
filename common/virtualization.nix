{ config, pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # Portainer agent port
  networking.firewall.allowedTCPPorts = [ 9001 ];
  networking.firewall.allowedUDPPorts = [ 9001 ];
}
