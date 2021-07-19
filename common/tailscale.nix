{ config, pkgs, ... }:

{
  services.tailscale.enable = true;

  services.tailscale.package = pkgs.tailscale;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [
    config.services.tailscale.port
  ];
}
