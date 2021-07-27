{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    ksquares
    kapman
    kdiamond
    granatier

    legendary-gl
    multimc

    sidequest
  ];
  
  # Enable steam
  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;
  hardware.steam-hardware.enable = true;
}
