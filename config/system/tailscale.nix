{ config, pkgs, ... }:

{
  services.tailscale.enable = true;

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
