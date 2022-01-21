{ pkgs, ... }:

{
  imports = [
    ./default.nix
  ];

  services.k3s = {
    role = "agent";
    serverAddr = "https://100.114.164.19:6443";
    tokenFile = ./token;
  };
}
