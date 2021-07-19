{ pkgs, ... }:

{
  # use gnome keyring
  services.gnome.gnome-keyring.enable = true;

  services.greetd = {
    enable = true;

    settings.default_session.command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
  };

  # Enable sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

     extraPackages = with pkgs; [
      swaylock-fancy
      swayidle
      wl-clipboard
      mako
      wofi
      waybar
      sway-contrib.grimshot
      swaybg

      adwaita-qt
      gnome3.adwaita-icon-theme
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
    dolphin

    vscode

    discord
    slack
    zoom-us
    libreoffice
    apple-music-electron

    multimc
  ];
  
  programs.waybar.enable = true;

  # Expose barrier in firewall
  # networking.firewall.allowedTCPPorts = [ 24800 ];
  # networking.firewall.allowedUDPPorts = [ 24800 ];
}
