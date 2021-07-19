{ pkgs, ... }:

{
  # Enable sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

     extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      wofi
      waybar
      sway-contrib.grimshot

      adwaita-qt
      gnome3.adwaita-icon-theme
      gnome3.networkmanagerapplet
    ];
  };

  # Configuration
  programs.xwayland.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    brave
    
    feh
    gparted
    psensor

    vscode

    discord
    slack
    zoom-us
    libreoffice
    apple-music-electron

    multimc
  ];

  # Programs
  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;

  programs.waybar.enable = true;


  # Expose barrier in firewall
  # networking.firewall.allowedTCPPorts = [ 24800 ];
  # networking.firewall.allowedUDPPorts = [ 24800 ];
}
