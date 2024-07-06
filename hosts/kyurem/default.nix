{ pkgs, ... }:

{
  imports = [

  ];

  networking = {
    # System hostname
    hostName = "kyurem";

    knownNetworkServices = [
      "Wi-Fi"
      "USB 10/100/1000 LAN"
    ];
  };
}
