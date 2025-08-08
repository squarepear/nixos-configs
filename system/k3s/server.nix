{ ... }:

{
  imports = [
    ./default.nix
  ];

  services.k3s.role = "server";

  # k3s server port
  networking.firewall.allowedTCPPorts = [ 6443 ];
}
