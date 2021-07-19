{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    ksquares
    kapman
    kdiamond
    granatier
  ];
  
  # Enable steam
  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;
}