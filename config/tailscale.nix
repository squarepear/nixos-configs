{ config, pkgs, ... }:

{
  services.tailscale.enable = true;

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    checkReversePath = "loose";
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.extraHosts = ''
    100.109.69.13   altaria
    100.116.153.120 reshiram
    100.112.83.22   tepig
    100.64.28.74    torchic
    100.109.35.9    darkrai
    100.68.216.104  genesect
    100.102.1.102   keldeo
    100.66.3.126    kyurem
  '';

  my.programs.zsh = {
    shellAliases = {
      "ts" = "tailscale";
    };
  };
}
