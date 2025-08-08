{ ... }:

{
  imports = [
    ./default.nix
  ];

  services.k3s = {
    role = "agent";
    serverAddr = "https://tepig:6443";
    tokenFile = ../k3s/token;
  };
}
